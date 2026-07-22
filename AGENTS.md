# AGENTS.md

Guidance for coding agents working in this repository.

## Project

Static portfolio/documentation site ("Bridge to Purpose") for GitHub Pages. All content lives under `docs/`. There is no build system, package manager, or test framework — pages are self-contained HTML, CSS, and JavaScript.

## Git history (strict)

`main` must stay **strictly linear** — no merge commits.

- Land changes with **squash merge** or **rebase merge** only. Never use a merge commit into `main`.
- Rebase feature branches onto latest `main` before opening or updating a PR; do not merge `main` into the feature branch.
- The workflow `.github/workflows/linear-history.yml` fails if merge commits appear on `main` or in PRs targeting `main`.
- Repo admins should run `./scripts/enable-linear-history.sh` once to disable merge commits and activate the GitHub ruleset `required_linear_history` on `main`.

## Cursor Cloud specific instructions

- No dependency install is required. The update script in `.cursor/environment.json` only verifies Python and the `docs/` tree.
- Preview the site with `python3 -m http.server 8000 --directory docs` (also started automatically via the `docs-server` terminal). Visit `http://localhost:8000`.
- Deployable content is only under `docs/`. Edits outside that folder do not affect the live GitHub Pages site.
- Theme toggles and other shared UI are duplicated per HTML file; update each page individually when changing shared patterns.
- Pushes to `main` deploy `docs/` via `.github/workflows/digi-mar-ai-workflow.yml`.
