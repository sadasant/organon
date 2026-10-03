#!/usr/bin/env python3
"""Build and audit the nonbinding ontology-framework experiment."""
from pathlib import Path
import re
import subprocess
import sys

ROOT = Path(__file__).resolve().parent.parent
FORMAL = ROOT / 'ontology' / 'formal'
SOURCE = FORMAL / 'OntologyCompleteness.lean'


def main() -> int:
    source = SOURCE.read_text()
    theorems = set(re.findall(r'^theorem (\w+)', source, re.M))
    audits = re.findall(r'^#print axioms (\w+)', source, re.M)
    if set(audits) != theorems or len(audits) != len(theorems):
        raise ValueError('Each theorem must have exactly one axiom audit.')
    if re.search(r'\b(?:sorry|admit)\b|^\s*(?:axiom|opaque)\s', source, re.M):
        raise ValueError('Proof placeholders and new axiom/opaque declarations are forbidden.')
    subprocess.run(['lake', 'build'], cwd=FORMAL, check=True)
    result = subprocess.run(['lake', 'env', 'lean', SOURCE.name], cwd=FORMAL,
                            capture_output=True, text=True)
    output = result.stdout + result.stderr
    if result.returncode or 'warning:' in output:
        print(output, end='')
        return result.returncode or 1
    checked = re.findall(r"'[^']+\.(\w+)' (?:does not depend on any axioms|depends on axioms:)", output)
    if set(checked) != theorems or len(checked) != len(theorems):
        raise ValueError('Lean output must audit every theorem exactly once.')
    allowed = {'propext', 'Classical.choice', 'Quot.sound'}
    for block in re.findall(r'depends on axioms:\s*\[([^]]*)\]', output, re.S):
        dependencies = {name.strip() for name in block.split(',') if name.strip()}
        if dependencies - allowed:
            raise ValueError(f'Unapproved proof dependencies: {dependencies - allowed}')
    print(output, end='')
    print(f'Framework experiment passed: {len(theorems)} checked theorems; '
          'no proof placeholders or nonstandard axiom dependencies.')
    return 0


if __name__ == '__main__':
    try:
        sys.exit(main())
    except (ValueError, subprocess.CalledProcessError) as error:
        print(f'Framework experiment failed: {error}', file=sys.stderr)
        sys.exit(1)
