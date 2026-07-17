# AGENTS.md

Guidance for coding agents working in this repository.

## Project

Static portfolio/documentation site ("Bridge to Purpose") for GitHub Pages. All content lives under `docs/`. There is no build system, package manager, or test framework — pages are self-contained HTML, CSS, and JavaScript.

## Cursor Cloud specific instructions

- No dependency install is required. The update script in `.cursor/environment.json` only verifies Python and the `docs/` tree.
- Preview the site with `python3 -m http.server 8000 --directory docs` (also started automatically via the `docs-server` terminal). Visit `http://localhost:8000`.
- Deployable content is only under `docs/`. Edits outside that folder do not affect the live GitHub Pages site.
- Theme toggles and other shared UI are duplicated per HTML file; update each page individually when changing shared patterns.
- Pushes to `main` deploy `docs/` via `.github/workflows/digi-mar-ai-workflow.yml`.
