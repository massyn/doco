# Features

## Output formats

| Format | Flag | Notes |
|--------|------|-------|
| HTML   | `--format html` | Default |
| PDF    | `--format pdf`  | Requires Playwright |

## Table of contents

Pass `--toc` to generate a TOC, and `--toc-depth N` to limit heading depth.

## Themes

Themes are self-contained Jinja2 files with embedded CSS. Use `--theme NAME`
to switch. The `default` theme is used when no theme is specified.

## Code blocks

Python example:

```python
def greet(name: str) -> str:
    return f"Hello, {name}!"

print(greet("world"))
```

Bash example:

```bash
mddoco ./docs --title "Docs" --toc --format pdf --output ./out
```

## Blockquotes

> This is a blockquote. It can span multiple lines and supports **inline
> formatting** as well.
