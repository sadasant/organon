#!/usr/bin/env python3
"""Check the partial Bend migration, its inventory, and adversarial proof edits."""
from __future__ import annotations
import argparse
import hashlib
import json
import os
from pathlib import Path
import re
import shutil
import subprocess
import sys
import tempfile
import time

ROOT = Path(__file__).resolve().parent.parent
FORMAL = ROOT / 'ontology/formal'
BEND_ROOT = FORMAL / 'bend'
ENV = dict(os.environ, BEND_NO_TELEMETRY='1')


def invoke(command: list[str], cwd: Path = ROOT) -> dict:
    start = time.perf_counter()
    result = subprocess.run(command, cwd=cwd, env=ENV, text=True,
                            stdout=subprocess.PIPE, stderr=subprocess.STDOUT, timeout=60)
    return {'command': command, 'exit': result.returncode,
            'seconds': time.perf_counter() - start, 'output': result.stdout}


def clean(result: dict) -> bool:
    # Exit 0 also admits @unsafe. Require the exact pinned check-only verdict.
    return result['exit'] == 0 and result['output'].strip() == 'All terms check.'


def inventory() -> dict:
    coverage = json.loads((BEND_ROOT / 'coverage.json').read_text())
    baseline = coverage['baseline_commit']
    if not re.fullmatch(r'[0-9a-f]{40}', baseline) or invoke(['git', 'merge-base', '--is-ancestor', baseline, 'HEAD'])['exit']:
        raise ValueError('coverage baseline must be a full ancestor commit')
    actual_modules = {p.name for p in FORMAL.glob('*.lean')}
    if set(coverage['modules']) != actual_modules:
        raise ValueError('Lean module inventory is stale')
    mapped = []
    theorem_count = 0
    for name, module in coverage['modules'].items():
        path = FORMAL / name
        if hashlib.sha256(path.read_bytes()).hexdigest() != module['sha256']:
            raise ValueError(f'Lean source changed; review migration coverage: {name}')
        historical = subprocess.run(['git', 'show', f'{baseline}:ontology/formal/{name}'],
                                    cwd=ROOT, capture_output=True, check=True).stdout
        if hashlib.sha256(historical).hexdigest() != module['sha256']:
            raise ValueError(f'coverage digest does not match its baseline commit: {name}')
        declarations = re.findall(r'^(theorem|def|structure|abbrev|inductive)\s+([\w.]+)', path.read_text(), re.M)
        if declarations != [(d['kind'], d['name']) for d in module['declarations']]:
            raise ValueError(f'declaration inventory mismatch: {name}')
        for declaration in module['declarations']:
            if declaration['status'] not in {'pending', 'translated-candidate', 'interface-decision', 'classical-premise-decision'}:
                raise ValueError(f'unknown coverage status: {name}: {declaration}')
            theorem_count += declaration['kind'] == 'theorem'
            if declaration['status'] == 'translated-candidate':
                if declaration['kind'] != 'theorem':
                    raise ValueError('only corresponding theorems count as checked laws')
                mapped.append(declaration['bend_law'])
    laws = re.findall(r'^law (\w+):', (BEND_ROOT / 'LAWS.bend').read_text(), re.M)
    if len(set(mapped)) != len(mapped) or sorted(mapped) != sorted(laws):
        raise ValueError('Bend laws must map one-to-one to recorded Lean theorem candidates')
    return {'baseline_theorems': theorem_count, 'bend_candidates': len(laws),
            'remaining_theorems': theorem_count - len(laws)}


def mutate(source: Path, target: str, before: str, after: str) -> None:
    path = source / target
    text = path.read_text()
    if text.count(before) != 1:
        raise ValueError(f'mutation must hit exactly once: {target}: {before}')
    path.write_text(text.replace(before, after))


def check(binary: str, mutations: bool) -> dict:
    version = invoke([binary, 'version'])
    pin = json.loads((BEND_ROOT / 'toolchain.json').read_text())
    if version['exit'] or version['output'].strip() != f"bend {pin['version']}":
        raise ValueError(f"expected Bend {pin['version']}: {version['output']}")
    results = {'version': version['output'].strip(), 'inventory': inventory(), 'checks': {}}
    def run(name: str, path: Path, expected: str = 'clean') -> None:
        result = invoke([binary, str(path), '--check-only'])
        results['checks'][name] = result
        if expected == 'clean':
            passed = clean(result)
        elif expected == 'affine-rejection':
            passed = result['exit'] != 0 and 'consumed more than once' in result['output']
        elif expected == 'unsafe-notice':
            passed = result['exit'] == 0 and not clean(result) and 'unsafe' in result['output']
        else:
            passed = result['exit'] != 0 and expected in result['output']
        if not passed:
            raise ValueError(f"unexpected {name} result: {result}")
    run('proofs', BEND_ROOT / 'PROOF.bend')
    run('generic-empty-equivalence', BEND_ROOT / 'probes/EmptyEquiv.bend', 'affine-rejection')
    run('closed-template-equivalence', BEND_ROOT / 'probes/EmptyEquivTemplate.bend')
    run('open-classical-law', BEND_ROOT / 'probes/Classical.bend', 'TODO')
    run('explicit-classical-assumption', BEND_ROOT / 'probes/ClassicalAssumption.bend')
    if mutations:
        edits = [
            ('false-admission', 'LAWS.bend',
             'law boundaryRejectsBreaking:\n  Model.permits(Model.direction(), Model.breakMachine()) -> Empty',
             'law boundaryRejectsBreaking:\n  Model.permits(Model.direction(), Model.activate()) -> Empty', 'Error:'),
            ('identity-collapse', 'Model.bend',
             '        case Broken{}: Empty\n        case _: Unit',
             '        case Broken{}: Unit\n        case _: Unit', 'Error:'),
            ('missing-proof', 'PROOF.bend',
             'def Laws.boundaryAdmitsActivation(): Unit{}', '', 'TODO'),
            ('unsafe-proof', 'PROOF.bend',
             'def Laws.boundaryAdmitsActivation(): Unit{}',
             '@unsafe\ndef Laws.boundaryAdmitsActivation(): Unit{}', 'unsafe-notice'),
        ]
        for name, target, before, after, expected in edits:
            with tempfile.TemporaryDirectory(prefix='organon-bend-mutation-') as directory:
                copy = Path(directory) / 'bend'
                shutil.copytree(BEND_ROOT, copy)
                mutate(copy, target, before, after)
                run(name, copy / 'PROOF.bend', expected)
    results['source_sha256'] = {
        str(path.relative_to(ROOT)): hashlib.sha256(path.read_bytes()).hexdigest()
        for path in sorted([*BEND_ROOT.rglob('*.bend'), BEND_ROOT/'coverage.json',
                            BEND_ROOT/'toolchain.json', ROOT/'scripts/check-bend.py',
                            ROOT/'scripts/install-bend.py'])}
    return results


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--no-mutations', action='store_true')
    parser.add_argument('--record', type=Path, help='write command evidence to this JSON file')
    args = parser.parse_args()
    binary = os.environ.get('BEND_BIN') or shutil.which('bend')
    if not binary:
        parser.error('set BEND_BIN or install the pinned compiler with scripts/install-bend.py')
    try:
        results = check(binary, not args.no_mutations)
        if args.record:
            # Store portable commands; actual diagnostics and timings stay intact.
            for name, result in results['checks'].items():
                path = Path(result['command'][1])
                label = str(path.relative_to(ROOT)) if path.is_relative_to(ROOT) else f'<mutation:{name}>/PROOF.bend'
                result['command'] = ['bend', label, '--check-only']
                result['output'] = result['output'].replace(str(ROOT) + '/', '')
            results['repository_commit'] = invoke(['git', 'rev-parse', 'HEAD'])['output'].strip()
            args.record.write_text(json.dumps(results, indent=2) + '\n')
        counts = results['inventory']
        print(f"Bend candidate check passed: {counts['bend_candidates']}/{counts['baseline_theorems']} theorem candidates; {counts['remaining_theorems']} remain on Lean.")
        print(f"{len(results['checks'])} proof/interface/mutation checks passed; this is not migration completion.")
        return 0
    except (ValueError, OSError, subprocess.SubprocessError) as exc:
        print(f'Bend candidate check failed: {exc}', file=sys.stderr)
        return 1

if __name__ == '__main__':
    raise SystemExit(main())
