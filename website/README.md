# Sentinel CI Website

This folder contains the public Docusaurus site for Sentinel CI.

## Source of truth

The published docs are read directly from the repository root `docs/`. Do not duplicate documentation inside this folder.

## Local development

```bash
npm install
npm start
```

## Production build

```bash
npm run build
```

## Deployment

GitHub Pages deployment is handled by the repository workflow at `../.github/workflows/deploy-docs.yml`.
