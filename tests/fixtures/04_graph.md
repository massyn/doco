# Graph Support

## Simple bar chart

```graph
{
  "title": "Basic Graph Test",
  "orientation": "vertical",
  "show_legend": false,
  "data": {
    "x": ["A", "B", "C"],
    "Values": [10, 20, 15]
  },
  "series": [
    { "label": "Values", "type": "bar", "colour": "#2d6cbe" }
  ]
}
```

## Bare minimum (data only — all defaults applied)

Only `data` is required. Series are inferred from keys, type defaults to line, colour defaults to blue.

```graph
{
  "data": {
    "x": ["Jan", "Feb", "Mar", "Apr"],
    "Sales": [100, 150, 120, 180]
  }
}
```

## Single-quoted and Python-style booleans

```graph
{
  'title': 'Single Quote Test',
  'show_legend': False,
  'data': {
    'x': ['X', 'Y', 'Z'],
    'Count': [5, 10, 7]
  }
}
```
