# Obsidian vault projection

Organon's Git tree is canonical. Its copy inside an Obsidian vault is a
one-way, manifest-governed projection for reading and review—not a second Git
checkout and not an independent editing authority.

This boundary prevents Git, Obsidian Sync, and multiple devices from assigning
different identities to the same apparent file. Private notes, inline feedback,
generated samples, and unpublished drafts belong in a sibling workspace rather
than inside the public repository projection.

## Recommended layout

```text
~/Code/github.com/sadasant/organon/   # clean canonical Git checkout

<vault>/Contexts/
├── Organon/                          # generated public projection
└── Organon-Workspace/                # private notes flowing back to Git
    ├── Home.md
    ├── Inbox.md
    ├── Feedback/
    ├── Drafts/
    ├── Samples/
    ├── Evaluations/
    └── sync-status.md
```

The projection contains only files reported by `git ls-files` plus
`organon-sync-manifest.json`. The manifest records the source repository,
branch, exact commit, synchronization time, and digest of every projected file.

## Commands

Use an explicit destination. The examples intentionally avoid depending on one
private vault path:

```sh
python3 scripts/sync-vault.py plan \
  --destination /absolute/path/to/vault/Contexts/Organon

python3 scripts/sync-vault.py apply \
  --destination /absolute/path/to/vault/Contexts/Organon \
  --status-note /absolute/path/to/vault/Contexts/Organon-Workspace/sync-status.md

python3 scripts/sync-vault.py verify \
  --destination /absolute/path/to/vault/Contexts/Organon
```

`status` and `plan` report additions, updates, managed removals, edited mirror
files, and unmanaged files. `apply` requires a clean source worktree whose
structure contract passes. It stages the complete projection beside the
destination and swaps the directory only after every source file has been
copied and hashed.

## Failure policy

The synchronizer fails closed when:

- the source worktree is dirty;
- the source structure contract fails;
- a tracked source path is a symlink or is not a regular file;
- the destination lacks a valid manifest but already exists;
- a previously projected file was edited in the vault;
- an unmanaged file appears inside the projection;
- source and destination overlap.

Only paths listed in the previous manifest can be removed by a later sync. The
tool never interprets an unrecognized destination file as disposable.

Do not add a `.gitignore` rule for files such as `ontology 2.md`. A numbered
sibling is evidence of a sync conflict. Hiding it would preserve the conflict
while removing its visibility. Organon's structure checker rejects these names
in canonical source, and the vault synchronizer treats them as unmanaged files.

## Working from Obsidian

Treat `Contexts/Organon` as read-only. Record a proposed change in
`Contexts/Organon-Workspace/Feedback/` or `Inbox.md`, quoting or linking the
canonical passage. A Git branch can then incorporate that feedback through the
normal review process.

This is a return channel, not automatic two-way synchronization. It allows
phone-originated work without making whichever device wrote last the authority
over the ontology.

## Initial migration

Before the first projection:

1. preserve every unique private note in `Organon-Workspace`;
2. verify the preserved paths and hashes;
3. retain a recoverable backup of the old mixed checkout;
4. initialize `Contexts/Organon` from one clean source worktree;
5. run `verify` and the vault filename linter;
6. remove the backup only after Obsidian Sync and private navigation are
   confirmed on another device.

The migration is deliberately separate from ordinary `apply`: an existing
directory without a manifest is never silently claimed or replaced.
