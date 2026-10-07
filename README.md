# Verkís Reference

Public sanitized reference repository for external AI coding assistants such as Claude Code, Codex, and other development tools.

This repository contains reusable, non-secret reference material:

- startup prompts,
- project templates,
- workflow standards,
- context and memory rules,
- agent and skill templates,
- mirror sync scripts,
- public-safe documentation.

## Start here

Read:

1. `START_HERE.md`
2. `PERSONALITY.md`
3. `CLAUDE.md`
4. `CODEX.md`
5. `docs/prompts/initial-external-startup-prompt.md`

## Security rule

This is a public repository.

Do not commit secrets, private keys, tokens, client documents, raw internal network maps, raw NAS files, raw Proxmox audits, or private GitLab exports.

## Maintain this mirror

`bash scripts/public_mirror_sync.sh` generates local files from the recorded Common Ops revision. It never stages, commits or pushes. Review the resulting diff, run `python3 -m unittest discover -s tests -v` and `bash scripts/verify_public_repo.sh`, then submit a focused branch. CI validates pull requests and deploys only the main branch. Secret detection prints filenames rather than matching values.
