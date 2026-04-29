from importlib.resources import files
from pathlib import Path

from jinja2 import Environment, FileSystemLoader, TemplateNotFound


def _make_env() -> Environment:
    themes_dir = files("mddoco").joinpath("themes")
    return Environment(
        loader=FileSystemLoader(str(themes_dir)),
        autoescape=True,
    )


def render_html(
    sections: list[tuple[Path, str]],
    title: str | None = None,
    toc_html: str | None = None,
    theme: str = "default",
    has_mermaid: bool = False,
) -> str:
    """Render a full HTML document from (path, html_fragment) pairs."""
    env = _make_env()
    try:
        template = env.get_template(f"{theme}.html")
    except TemplateNotFound:
        raise ValueError(f"Theme '{theme}' not found.")
    return template.render(
        title=title,
        toc_html=toc_html,
        sections=sections,
        has_mermaid=has_mermaid,
    )
