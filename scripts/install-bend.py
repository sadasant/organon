#!/usr/bin/env python3
"""Install the pinned Bend archive into an explicit new directory, never $HOME."""
from __future__ import annotations
import argparse
import hashlib
import json
import os
from pathlib import Path, PurePosixPath
import platform
import shutil
import tarfile
import tempfile
import urllib.request

ROOT = Path(__file__).resolve().parent.parent

def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--dest', type=Path, required=True)
    args = parser.parse_args()
    dest = args.dest.resolve()
    if dest.exists():
        parser.error(f'destination already exists: {dest}')
    pin = json.loads((ROOT / 'ontology/formal/bend/toolchain.json').read_text())
    arch = {'arm64': 'arm64', 'aarch64': 'arm64', 'x86_64': 'x64', 'AMD64': 'x64'}.get(platform.machine())
    target = f'{platform.system().lower()}-{arch}'
    if target not in pin['archives']:
        parser.error(f'unsupported platform: {target}')
    name = f"bend-{pin['version']}-{target}.tar.gz"
    dest.parent.mkdir(parents=True, exist_ok=True)
    with tempfile.TemporaryDirectory(prefix='.bend-install-', dir=dest.parent) as tmp:
        work = Path(tmp)
        archive = work / name
        with urllib.request.urlopen(f"{pin['release']}/{name}", timeout=60) as response:
            with archive.open('wb') as output:
                shutil.copyfileobj(response, output)
        digest = hashlib.sha256(archive.read_bytes()).hexdigest()
        if digest != pin['archives'][target]:
            raise SystemExit('Bend archive checksum mismatch; nothing installed')
        with tarfile.open(archive) as tar:
            for member in tar.getmembers():
                path = PurePosixPath(member.name)
                if path.is_absolute() or '..' in path.parts or not path.parts or path.parts[0] != 'bend':
                    raise SystemExit(f'unsafe archive path: {member.name}')
                if not (member.isdir() or member.isfile()):
                    raise SystemExit(f'unsupported archive entry: {member.name}')
            tar.extractall(work, filter='data')
        executable = work / 'bend/bin/bend'
        if not executable.is_file():
            raise SystemExit('Bend archive has no executable')
        executable.chmod(executable.stat().st_mode | 0o100)
        os.rename(work / 'bend', dest)
    print(dest / 'bin/bend')

if __name__ == '__main__':
    main()
