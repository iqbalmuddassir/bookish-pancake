# Bridge to Purpose

Static portfolio and documentation site by [Muddassir Iqbal](https://github.com/iqbalmuddassir). A hub linking to featured projects—digital marketing guides, Islamic app documentation, and business courses—built with vanilla HTML, CSS, and JavaScript.

**Live site:** [https://iqbalmuddassir.github.io/bookish-pancake/](https://iqbalmuddassir.github.io/bookish-pancake/)

## Projects

| Project | Description |
|---------|-------------|
| [Digital Marketing AI](https://iqbalmuddassir.github.io/bookish-pancake/digital-marketing-ai/) | 3-month freelancer roadmap for AI-assisted digital marketing |
| [Al-Quran Education](https://iqbalmuddassir.github.io/bookish-pancake/quran-education-app/) | App documentation: recitations, translations, AI Halal checking, prayer tools |
| [Local Lead Gen Agency](https://iqbalmuddassir.github.io/bookish-pancake/local-lead-gen-agency/) | 14-module self-study course for building a local lead gen agency in India |
| [Amanah India](https://iqbalmuddassir.github.io/bookish-pancake/amanah-india/) | Internal project summary for an Islamic e-commerce marketplace |

## Repository structure

All site content lives under `docs/`:

```
docs/
├── index.html                          # Portfolio landing page
├── digital-marketing-ai/index.html
├── quran-education-app/
│   ├── index.html
│   └── terms_and_conditions.html
├── local-lead-gen-agency/index.html
└── amanah-india/index.html
```

## Local development

No build step or package manager is required. Open any HTML file in a browser, or serve the `docs/` folder locally:

```bash
cd docs && python3 -m http.server 8000
```

Then visit [http://localhost:8000](http://localhost:8000).

## Deployment

Pushes to `main` trigger the GitHub Actions workflow (`.github/workflows/digi-mar-ai-workflow.yml`), which deploys the `docs/` directory to GitHub Pages. No manual deploy step is needed.

## Tech stack

- **HTML, CSS, JavaScript** — no frameworks or bundlers
- **Theming** — dark/light mode via CSS custom properties; preference stored in `localStorage`
- **Typography** — Plus Jakarta Sans (hub), Inter (sub-pages), loaded from Google Fonts

Each page is self-contained with inline styles and scripts.

## License

© Muddassir Iqbal. All rights reserved.
