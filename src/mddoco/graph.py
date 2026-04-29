import io
import json
import re
from html import escape, unescape

import matplotlib
matplotlib.use('Agg')  # non-interactive backend — must be set before importing pyplot
import matplotlib.pyplot as plt

_DEFAULT_COLOURS = [
    '#2d6cbe', '#e74c3c', '#27ae60', '#e67e22',
    '#8e44ad', '#16a085', '#2c3e50', '#d35400',
]


def graph_it(data, output=None):
    dpi = 100
    width_px = data.get('width_px', 640)
    height_px = data.get('height_px', 480)
    fig, ax = plt.subplots(figsize=(width_px / dpi, height_px / dpi), dpi=dpi)

    orientation = data.get('orientation', 'vertical').lower()
    if orientation not in ('horizontal', 'vertical'):
        raise ValueError(
            f"Invalid orientation '{orientation}' — must be 'horizontal' or 'vertical'"
        )
    horizontal = orientation == 'horizontal'

    x = data['data']['x']

    # Auto-generate series from data keys (everything except 'x') if not provided
    series_list = data.get('series') or [
        {'label': k} for k in data['data'] if k != 'x'
    ]

    for i, series in enumerate(series_list):
        label = series['label']
        values = data['data'][label]
        series_type = series.get('type', 'line')
        colour = series.get('colour', _DEFAULT_COLOURS[i % len(_DEFAULT_COLOURS)])

        if series_type == 'bar':
            colour_val = colour if isinstance(colour, list) else [colour] * len(values)
            if horizontal:
                ax.barh(x, values, color=colour_val, label=label)
            else:
                ax.bar(x, values, color=colour_val, label=label)
        elif series_type in ('line', 'line2'):
            marker = 'o' if series.get('marker', False) else 'None'
            linestyle = ':' if series_type == 'line2' else '-'
            if horizontal:
                ax.plot(values, x, color=colour, marker=marker, linewidth=2, linestyle=linestyle, label=label)
            else:
                ax.plot(x, values, color=colour, marker=marker, linewidth=2, linestyle=linestyle, label=label)

    if 'min' in data or 'max' in data:
        lo = data.get('min', None)
        hi = data.get('max', None)
        if horizontal:
            ax.set_xlim(lo, hi)
        else:
            ax.set_ylim(lo, hi)

    title = data.get('title', '')
    if title:
        ax.set_title(title)

    if data.get('show_legend', True):
        ax.legend(loc='upper left')

    ax.spines['top'].set_visible(False)
    ax.spines['right'].set_visible(False)

    if output:
        plt.savefig(output, format="svg", bbox_inches='tight')
        plt.close(fig)
    else:
        buf = io.StringIO()
        plt.savefig(buf, format="svg", bbox_inches='tight')
        plt.close(fig)
        return buf.getvalue()


_GRAPH_BLOCK = re.compile(
    r'<pre><code class="language-graph">(.*?)</code></pre>',
    re.DOTALL,
)

_SVG_HEADER = re.compile(r'^.*?(?=<svg)', re.DOTALL)


def _render_graph(source: str) -> str:
    """Parse JSON source, render via graph_it, and return an inline SVG element."""
    data = json.loads(unescape(source))
    svg = graph_it(data)
    svg = _SVG_HEADER.sub('', svg)  # strip XML declaration and DOCTYPE
    return f'<div class="graph">{svg}</div>'


def process_graph(html: str) -> tuple[str, bool]:
    """Replace fenced graph blocks with rendered SVG charts.

    Falls back to an inline error message if the block cannot be parsed or rendered.
    Returns (processed_html, found).
    """
    found = bool(_GRAPH_BLOCK.search(html))

    def replace(m: re.Match) -> str:
        try:
            return _render_graph(m.group(1))
        except Exception as exc:
            return (
                f'<p class="graph-error"><strong>Graph error:</strong> '
                f'{escape(str(exc))}</p>'
            )

    return _GRAPH_BLOCK.sub(replace, html), found
