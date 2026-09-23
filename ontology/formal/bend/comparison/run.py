#!/usr/bin/env python3
"""Bounded migration probes. Never writes into the Organon checkout."""
import hashlib
import json
import os
from pathlib import Path
import platform
import shutil
import statistics
import subprocess
import time

ROOT = Path(__file__).resolve().parent
REPO = Path(os.environ.get('ORGANON_REPO', str(ROOT.parents[3])))
BEND = os.environ.get('BEND_BIN', 'bend')
ENV = dict(os.environ, BEND_NO_TELEMETRY='1')

def run(args, cwd=ROOT):
    start = time.perf_counter()
    p = subprocess.run(list(map(str, args)), cwd=cwd, env=ENV, text=True,
                       stdout=subprocess.PIPE, stderr=subprocess.STDOUT, timeout=120)
    return dict(command=list(map(str, args)), cwd=str(cwd), exit=p.returncode,
                seconds=time.perf_counter()-start, output=p.stdout)

def success(result):
    if result['exit'] != 0:
        raise RuntimeError(result)
    return result

lean_path = success(run(['lake', 'env', 'which', 'lean'], REPO/'ontology/formal'))['output'].strip()
results = dict(platform=platform.platform(), machine=platform.machine(),
               organon_commit=success(run(['git', 'rev-parse', 'HEAD'], REPO))['output'].strip(),
               bend_version=success(run([BEND, 'version']))['output'].strip(),
               lean_version=success(run([lean_path, '--version']))['output'].strip(), cases={})
for name in ['Equivalent', 'Contraction', 'Classical', 'False', 'Unsafe', 'ReusableData']:
    results['cases'][name] = {
        'bend': run([BEND, ROOT/f'{name}.bend', '--check-only']),
        'lean': run([lean_path, ROOT/f'{name}.lean'])}
expected = {'Equivalent':(0,0), 'Contraction':(1,0), 'Classical':(1,0), 'False':(1,1), 'Unsafe':(0,1), 'ReusableData':(0,0)}
for name, (bend_exit, lean_exit) in expected.items():
    assert results['cases'][name]['bend']['exit'] == bend_exit, results['cases'][name]
    assert results['cases'][name]['lean']['exit'] == lean_exit, results['cases'][name]
assert 'unsafe' in results['cases']['Unsafe']['bend']['output'].lower()
# Warm both processes once; alternate ordering across seven measured pairs.
commands = {'bend':[BEND, ROOT/'Equivalent.bend', '--check-only'],
            'lean':[lean_path, ROOT/'Equivalent.lean']}
for cmd in commands.values():
    success(run(cmd))
samples = {'bend':[], 'lean':[]}
for i in range(7):
    for label in (['bend','lean'] if i % 2 == 0 else ['lean','bend']):
        samples[label].append(success(run(commands[label]))['seconds'])
results['timings'] = {k:dict(samples_seconds=v, median_seconds=statistics.median(v)) for k,v in samples.items()}
# Fresh artifact directory each run, but OS/toolchain caches are not flushed.
import tempfile
with tempfile.TemporaryDirectory(prefix='organon-lean-baseline-') as temp:
    base = Path(temp)
    for src in (REPO/'ontology/formal').iterdir():
        if src.suffix == '.lean' or src.name in ('lakefile.toml', 'lean-toolchain', 'lake-manifest.json'):
            shutil.copy2(src, base/src.name)
    results['baseline_fresh_artifacts'] = success(run(['lake', 'build'], base))
    results['baseline_incremental'] = success(run(['lake', 'build'], base))
    results['finite_models'] = success(run(['lake', 'exe', 'ontology_check'], base))
results['fixture_sha256'] = {p.name:hashlib.sha256(p.read_bytes()).hexdigest() for p in sorted(ROOT.iterdir()) if p.suffix in ('.bend','.lean')}
(ROOT/'results.json').write_text(json.dumps(results, indent=2)+'\n')
print(json.dumps(dict(versions=[results['bend_version'],results['lean_version']],
    cases={k:{lang:r['exit'] for lang,r in v.items()} for k,v in results['cases'].items()},
    medians={k:v['median_seconds'] for k,v in results['timings'].items()},
    baseline_fresh=results['baseline_fresh_artifacts']['seconds'],
    baseline_incremental=results['baseline_incremental']['seconds']), indent=2))
