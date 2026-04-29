import re

_INNER_UL = re.compile(r"<ul>(.*)</ul>", re.DOTALL)


def combine_toc(fragments: list[str]) -> str:
    """Merge per-file TOC HTML fragments into a single <ul> block."""
    items: list[str] = []
    for fragment in fragments:
        m = _INNER_UL.search(fragment)
        if m:
            items.append(m.group(1).strip())
    if not items:
        return ""
    return "<ul>\n" + "\n".join(items) + "\n</ul>"
