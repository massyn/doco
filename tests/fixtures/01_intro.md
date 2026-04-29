# Introduction

Welcome to **mddoco** — a markdown to HTML and PDF converter.

## What it does

mddoco scans a folder for markdown files, sorts them, and combines them into a
single output document. It supports:

- HTML and PDF output
- Custom themes
- Table of contents generation
- Mermaid diagrams

## Getting started

Install the package and run the `mddoco` command pointing at any folder or file.

```bash
pip install mddoco
mddoco ./docs --title "My Project"
```

> Tip: use `--toc` to generate a table of contents from your headings.
