# AGENTS.md

Guidance for coding agents working in this repository.

## Project

Static portfolio/documentation site ("Bridge to Purpose") for GitHub Pages. All content lives under `docs/`. There is no build system, package manager, or test framework — pages are self-contained HTML, CSS, and JavaScript.

Public hub projects: Digital Marketing AI, Al-Quran Education (plus Android/iOS subpages), Local Lead Gen Agency.

Internal pages (Minimal Family House, Amanah India, Grab SEM Portfolio) are deployed under `docs/` but only listed on the hub when opened with `?mode=private`.

## Cursor Cloud specific instructions

- No dependency install is required. The update script in `.cursor/environment.json` only verifies Python and the `docs/` tree.
- Preview the site with `python3 -m http.server 8000 --directory docs` (also started automatically via the `docs-server` terminal). Visit `http://localhost:8000`. Use `http://localhost:8000/?mode=private` for internal hub cards.
- Deployable content is only under `docs/`. Edits outside that folder do not affect the live GitHub Pages site.
- Theme toggles and other shared UI are duplicated per HTML file; update each page individually when changing shared patterns.
- Hub/studio pages generally use Space Grotesk; Al-Quran Education uses Outfit + Cormorant Garamond.
- Pushes to `main` deploy `docs/` via `.github/workflows/digi-mar-ai-workflow.yml`.

## Git: linear history (strict)

This repository **must** keep a linear commit history on `main`. No exceptions.

- **Never** create merge commits (`git merge` without `--ff-only`, GitHub “Create a merge commit”, or merging `main` into a feature branch).
- Integrate work with **rebase** (`git rebase` / `git pull --rebase`) or **squash** onto `main` only.
- Keep feature branches up to date with `git fetch origin && git rebase origin/main` — not merge.
- If history becomes non-linear, rewrite it to linear (rebase/cherry-pick) and force-push only when the user explicitly requests a force push.
- GitHub is configured with merge commits disabled; only squash and rebase merges are allowed. Do not re-enable merge commits.
