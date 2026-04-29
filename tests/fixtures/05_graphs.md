# Graph Examples

## Vertical bar chart

```graph
{
  "title": "Quarterly Revenue",
  "orientation": "vertical",
  "show_legend": false,
  "data": {
    "x": ["Q1", "Q2", "Q3", "Q4"],
    "Revenue": [42000, 58000, 51000, 73000]
  },
  "series": [
    { "label": "Revenue", "type": "bar", "colour": "#2d6cbe" }
  ]
}
```

## Vertical line chart

```graph
{
  "title": "Website Visitors (Monthly)",
  "orientation": "vertical",
  "show_legend": true,
  "data": {
    "x": ["Jan", "Feb", "Mar", "Apr", "May", "Jun"],
    "Visitors": [1200, 1450, 1380, 1620, 1800, 2100]
  },
  "series": [
    { "label": "Visitors", "type": "line", "colour": "#27ae60", "marker": true }
  ]
}
```

## Vertical line2 (dotted line)

```graph
{
  "title": "Temperature — Actual vs Forecast",
  "orientation": "vertical",
  "show_legend": true,
  "data": {
    "x": ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"],
    "Actual":   [18, 20, 19, 22, 25, 23, 21],
    "Forecast": [17, 21, 20, 21, 24, 22, 20]
  },
  "series": [
    { "label": "Actual",   "type": "line",  "colour": "#2d6cbe", "marker": true  },
    { "label": "Forecast", "type": "line2", "colour": "#e67e22", "marker": false }
  ]
}
```

## Vertical bar and line (combo)

```graph
{
  "title": "Sales vs Target",
  "orientation": "vertical",
  "show_legend": true,
  "data": {
    "x": ["Jan", "Feb", "Mar", "Apr", "May"],
    "Sales":  [85, 92, 78, 96, 110],
    "Target": [90, 90, 90, 90, 90]
  },
  "series": [
    { "label": "Sales",  "type": "bar",  "colour": "#3498db" },
    { "label": "Target", "type": "line", "colour": "#e74c3c", "marker": false }
  ]
}
```

## Horizontal bar chart

```graph
{
  "title": "Team Performance Scores",
  "orientation": "horizontal",
  "show_legend": false,
  "data": {
    "x": ["Alice", "Bob", "Charlie", "Diana", "Eve"],
    "Score": [88, 72, 95, 81, 67]
  },
  "series": [
    { "label": "Score", "type": "bar", "colour": ["#2ecc71", "#3498db", "#2ecc71", "#e74c3c", "#3498db"] }
  ]
}
```

## Horizontal line and line2

```graph
{
  "title": "Response Time by Percentile",
  "orientation": "horizontal",
  "show_legend": true,
  "min": 0,
  "data": {
    "x": ["0ms", "50ms", "100ms", "150ms", "200ms"],
    "P50": [1000, 850, 600, 300, 100],
    "P95": [200,  150, 100,  50,  20]
  },
  "series": [
    { "label": "P50", "type": "line",  "colour": "#2d6cbe", "marker": true  },
    { "label": "P95", "type": "line2", "colour": "#e74c3c", "marker": false }
  ]
}
```
