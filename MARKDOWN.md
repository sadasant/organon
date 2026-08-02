# Markdown Policy

Organon has one source tree and two important renderers: Obsidian in the local vault and GitHub in the public repository. Repository-facing documents use the portable intersection of both rather than maintaining separate copies.

## Public and tracked documents

Use GitHub-flavored Markdown as the baseline:

- Link with `[label](./relative-path.md)`, which both GitHub and Obsidian resolve.
- Embed images with `![alt text](./assets/image.png)`.
- Use fenced code blocks with an explicit language when one exists.
- Use ordinary headings, lists, tables, emphasis, and blockquotes.
- Use `> [!NOTE]`, `> [!WARNING]`, or another shared alert form only when the callout materially helps the reader.
- Keep filenames portable across macOS, Linux, Windows, Git, and Obsidian Sync.
- Use YAML frontmatter only when a real metadata consumer requires it. A public README should not need frontmatter to explain itself.

Do not make a tracked public document depend on:

- Obsidian wikilinks such as `[[Document]]`;
- Obsidian transclusions such as `![[Document]]`;
- block references, Dataview queries, Canvas files, or plugin-generated state;
- links that resolve only from the root of Daniel's private Parergon vault.

## Vault-private documents

Private notes may use Obsidian-specific syntax when it improves navigation or context hydration. When such a note becomes part of the repository's public surface, convert its dependencies to relative Markdown links or publish the required target alongside it.

## Existing historical material

Archived files may retain Obsidian syntax when rewriting them would falsify the historical artifact. Active documents should migrate to portable syntax when they are substantively revised. Known private-vault references should be described as provenance rather than presented as public links.

## Verification

A repository-facing change is ready when:

1. GitHub can render every required link and image from the repository checkout.
2. Obsidian reports no unresolved links for the tracked active documents.
3. The vault filename linter reports no portability errors.
4. The document remains intelligible as raw text without an Obsidian plugin.

Run `python3 scripts/check-links.py` from the repository root to enforce the repository boundary. The checker scans tracked and staged Markdown, exempts immutable material under `History/`, and rejects active Obsidian wikilinks, private `Contexts/` paths, missing local targets, and links that escape the checkout.

The purpose is not renderer purity. It is to prevent the authoring environment from becoming an undeclared dependency of the argument.
