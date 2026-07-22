# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a static portfolio/documentation site ("Bridge to Purpose") hosted on **GitHub Pages**. There is no build system, no package manager, and no test framework — all pages are vanilla HTML, CSS, and JavaScript.

## Deployment

Pushes to `main` automatically trigger the GitHub Actions workflow (`.github/workflows/digi-mar-ai-workflow.yml`), which uploads the entire `docs/` directory to GitHub Pages. No manual deploy step is needed.

## Git: linear history (strict)

This repository **must** keep a linear commit history on `main`. No exceptions.

- **Never** create merge commits (`git merge` without `--ff-only`, GitHub “Create a merge commit”, or merging `main` into a feature branch).
- Integrate work with **rebase** (`git rebase` / `git pull --rebase`) or **squash** onto `main` only.
- Keep feature branches up to date with `git fetch origin && git rebase origin/main` — not merge.
- If history becomes non-linear, rewrite it to linear (rebase/cherry-pick) and force-push only when the user explicitly requests a force push.
- GitHub is configured with merge commits disabled; only squash and rebase merges are allowed. Do not re-enable merge commits.

## Repository Structure

All deliverables live under `docs/`:

- `docs/index.html` — Portfolio landing page (hub linking to all projects)
- `docs/digital-marketing-ai/index.html` — 3-month freelancer roadmap for AI-assisted digital marketing
- `docs/quran-education-app/index.html` — Al-Quran Education app documentation (Quran recitations, translations, AI Halal checking, prayer tools)
- `docs/quran-education-app/terms_and_conditions.html` — Legal terms for the Quran app
- `docs/local-lead-gen-agency/index.html` — 14-module self-study course: building a local lead gen agency in India (GBP, Meta Ads, automation, sales scripts)

## Architecture & Conventions

**Theming** — All pages implement a dark/light mode toggle via CSS custom properties (`--bg`, `--text`, etc.). The user's preference is persisted in `localStorage`. The hub (`docs/index.html`) also respects the OS `prefers-color-scheme` media query as a default.

**Typography** — `docs/index.html` uses **Plus Jakarta Sans** (Google Fonts); project sub-pages use **Inter**. Font loading is done via `<link>` in `<head>`.

**Styling approach** — Styles are written inline in `<style>` blocks within each HTML file (no external `.css` files). CSS variables drive the colour palette; `clamp()` is used for fluid typography and spacing.

**JavaScript** — Kept minimal and inline in `<script>` blocks. Only used for the theme toggle and minor DOM interactions.

**No shared components** — Each page is fully self-contained. If you need to update a shared element (e.g., navigation, footer), you must edit every file individually.
