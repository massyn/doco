#!/usr/bin/env bash
# Test runner for mddoco. Run from the repo root: bash tests/run_tests.sh

set -uo pipefail

FIXTURES="fixtures"
OUT="output"
PASS=0
FAIL=0

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

green() { printf '\033[0;32m%s\033[0m\n' "$*"; }
red()   { printf '\033[0;31m%s\033[0m\n' "$*"; }

pass() { green "  PASS: $1"; ((PASS++)); }
fail() { red   "  FAIL: $1"; ((FAIL++)); }

# run_test <label> <expected_output_file> <mddoco args...>
#   Runs mddoco, checks exit code, checks the output file exists and is non-empty.
run_test() {
    local label="$1"
    local expected_file="$2"
    shift 2

    if mddoco "$@" 2>&1; then
        if [[ -s "$expected_file" ]]; then
            pass "$label"
        else
            fail "$label — output file missing or empty: $expected_file"
        fi
    else
        fail "$label — mddoco exited with error"
    fi
}

# check_contains <label> <file> <pattern>
#   Greps for a pattern inside an output file.
check_contains() {
    local label="$1"
    local file="$2"
    local pattern="$3"

    if grep -q "$pattern" "$file" 2>/dev/null; then
        pass "$label"
    else
        fail "$label — pattern not found in $file: $pattern"
    fi
}

# check_not_contains <label> <file> <pattern>
check_not_contains() {
    local label="$1"
    local file="$2"
    local pattern="$3"

    if ! grep -q "$pattern" "$file" 2>/dev/null; then
        pass "$label"
    else
        fail "$label — unexpected pattern found in $file: $pattern"
    fi
}

# ---------------------------------------------------------------------------
# Setup
# ---------------------------------------------------------------------------

echo "Preparing output directory..."
rm -rf "$OUT"
mkdir -p "$OUT"

# Verify mddoco is on the PATH
if ! command -v mddoco &>/dev/null; then
    red "ERROR: mddoco not found. Run: pip install -e ."
    exit 1
fi

echo ""
echo "Running tests..."
echo "─────────────────────────────────────────────"

# ---------------------------------------------------------------------------
# 1. Single file → HTML
# ---------------------------------------------------------------------------
run_test \
    "single file input, HTML output" \
    "$OUT/single/single.html" \
    "$FIXTURES/single.md" -o "$OUT/single"

# ---------------------------------------------------------------------------
# 2. Directory → HTML (default options)
# ---------------------------------------------------------------------------
run_test \
    "directory input, HTML output" \
    "$OUT/dir/fixtures.html" \
    "$FIXTURES" -o "$OUT/dir"

# ---------------------------------------------------------------------------
# 3. Directory → HTML with title
# ---------------------------------------------------------------------------
run_test \
    "directory with --title" \
    "$OUT/titled/fixtures.html" \
    "$FIXTURES" --title "Test Suite Docs" -o "$OUT/titled"

check_contains \
    "title appears in HTML" \
    "$OUT/titled/fixtures.html" \
    "Test Suite Docs"

# ---------------------------------------------------------------------------
# 4. No title → title element omitted from body
# ---------------------------------------------------------------------------
run_test \
    "no title — doc-title class absent" \
    "$OUT/notitle/fixtures.html" \
    "$FIXTURES" -o "$OUT/notitle"

check_not_contains \
    "doc-title not rendered when title omitted" \
    "$OUT/notitle/fixtures.html" \
    'class="doc-title"'

# ---------------------------------------------------------------------------
# 5. TOC generation
# ---------------------------------------------------------------------------
run_test \
    "directory with --toc" \
    "$OUT/toc/fixtures.html" \
    "$FIXTURES" --toc -o "$OUT/toc"

check_contains \
    "TOC block present in output" \
    "$OUT/toc/fixtures.html" \
    "toc-block"

# ---------------------------------------------------------------------------
# 6. TOC disabled (default)
# ---------------------------------------------------------------------------
run_test \
    "no TOC by default" \
    "$OUT/notoc/fixtures.html" \
    "$FIXTURES" -o "$OUT/notoc"

check_not_contains \
    "toc-block absent when --no-toc" \
    "$OUT/notoc/fixtures.html" \
    'class="toc-block"'

# ---------------------------------------------------------------------------
# 7. TOC with limited depth
# ---------------------------------------------------------------------------
run_test \
    "--toc-depth 1 (H1 only)" \
    "$OUT/toc_depth/fixtures.html" \
    "$FIXTURES" --toc --toc-depth 1 -o "$OUT/toc_depth"

# ---------------------------------------------------------------------------
# 8. Mermaid diagrams
# ---------------------------------------------------------------------------
run_test \
    "mermaid diagram file" \
    "$OUT/mermaid/03_diagrams.html" \
    "$FIXTURES/03_diagrams.md" -o "$OUT/mermaid"

check_contains \
    "mermaid div present" \
    "$OUT/mermaid/03_diagrams.html" \
    'class="mermaid"'

check_contains \
    "mermaid.js CDN loaded" \
    "$OUT/mermaid/03_diagrams.html" \
    "mermaid.min.js"

# ---------------------------------------------------------------------------
# 9. No mermaid → CDN not loaded
# ---------------------------------------------------------------------------
run_test \
    "no mermaid in plain file" \
    "$OUT/nomermaid/01_intro.html" \
    "$FIXTURES/01_intro.md" -o "$OUT/nomermaid"

check_not_contains \
    "mermaid.js CDN absent when no diagrams" \
    "$OUT/nomermaid/01_intro.html" \
    "mermaid.min.js"

# ---------------------------------------------------------------------------
# 10. PDF output (skipped if Playwright is not installed)
# ---------------------------------------------------------------------------
if python -c "import playwright" 2>/dev/null; then
    run_test \
        "single file → PDF" \
        "$OUT/pdf/single.pdf" \
        "$FIXTURES/single.md" --format pdf -o "$OUT/pdf"
else
    echo "  SKIP: PDF test — Playwright not installed"
fi

# ---------------------------------------------------------------------------
# 11. Graph rendering and error handling
# ---------------------------------------------------------------------------
run_test \
    "graph block file" \
    "$OUT/graph/04_graph.html" \
    "$FIXTURES/04_graph.md" -o "$OUT/graph"

check_contains \
    "valid graph block rendered as SVG" \
    "$OUT/graph/04_graph.html" \
    '<svg'

check_contains \
    "invalid graph block renders error notice" \
    "$OUT/graph/04_graph.html" \
    'graph-error'

check_not_contains \
    "raw graph fenced block not present in output" \
    "$OUT/graph/04_graph.html" \
    'class="language-graph"'

check_contains \
    "bare-minimum graph (data only) renders SVG" \
    "$OUT/graph/04_graph.html" \
    '<svg'

# ---------------------------------------------------------------------------
# 12. Comprehensive graph types
# ---------------------------------------------------------------------------
run_test \
    "comprehensive graph types" \
    "$OUT/graphs/05_graphs.html" \
    "$FIXTURES/05_graphs.md" -o "$OUT/graphs"

check_contains \
    "graphs: vertical bar rendered" \
    "$OUT/graphs/05_graphs.html" \
    "Quarterly Revenue"

check_contains \
    "graphs: vertical line rendered" \
    "$OUT/graphs/05_graphs.html" \
    "Website Visitors"

check_contains \
    "graphs: line2 (dotted) rendered" \
    "$OUT/graphs/05_graphs.html" \
    "Temperature"

check_contains \
    "graphs: bar and line combo rendered" \
    "$OUT/graphs/05_graphs.html" \
    "Sales vs Target"

check_contains \
    "graphs: horizontal bar rendered" \
    "$OUT/graphs/05_graphs.html" \
    "Team Performance"

check_contains \
    "graphs: horizontal line rendered" \
    "$OUT/graphs/05_graphs.html" \
    "Response Time"

# ---------------------------------------------------------------------------
# 13. Professional theme
# ---------------------------------------------------------------------------
run_test \
    "professional theme, directory with title and TOC" \
    "$OUT/professional/fixtures.html" \
    "$FIXTURES" --theme professional --title "Professional Demo" --toc -o "$OUT/professional"

check_contains \
    "professional theme: title banner rendered" \
    "$OUT/professional/fixtures.html" \
    'class="doc-header"'

check_contains \
    "professional theme: title text present" \
    "$OUT/professional/fixtures.html" \
    "Professional Demo"

check_contains \
    "professional theme: TOC block present" \
    "$OUT/professional/fixtures.html" \
    'class="toc-block"'

# ---------------------------------------------------------------------------
# 14. Invalid input path → non-zero exit
# ---------------------------------------------------------------------------
echo -n "  "
if ! mddoco "tests/fixtures/nonexistent.md" -o "$OUT/invalid" &>/dev/null; then
    pass "invalid input path exits non-zero"
else
    fail "invalid input path should have exited non-zero"
fi


# ---------------------------------------------------------------------------
# Summary
# ---------------------------------------------------------------------------
echo "─────────────────────────────────────────────"
TOTAL=$((PASS + FAIL))
echo "Results: $PASS/$TOTAL passed"

if [[ $FAIL -gt 0 ]]; then
    red "$FAIL test(s) failed."
    exit 1
else
    green "All tests passed."
    exit 0
fi
