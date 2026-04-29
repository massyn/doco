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

## Invalid graph (error handling)

The block below has invalid JSON and should render an error notice rather than crash:

```graph
{ this is not valid json }
```
