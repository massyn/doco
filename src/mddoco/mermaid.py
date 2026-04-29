import re

_MERMAID_BLOCK = re.compile(
    r'<pre><code class="language-mermaid">(.*?)</code></pre>',
    re.DOTALL,
)


def process_mermaid(html: str) -> tuple[str, bool]:
    """Replace fenced mermaid blocks with Mermaid.js div elements.

    Returns (processed_html, found) where found indicates whether any
    mermaid blocks were present.
    """
    found = bool(_MERMAID_BLOCK.search(html))
    processed = _MERMAID_BLOCK.sub(
        lambda m: f'<div class="mermaid">{m.group(1)}</div>',
        html,
    )
    return processed, found
