from pathlib import Path


def find_markdown_files(input_path: Path) -> list[Path]:
    """Return markdown files to process.

    If input_path is a file, return it directly (must be a .md file).
    If input_path is a directory, return all *.md files sorted by relative path.
    """
    if input_path.is_file():
        if input_path.suffix.lower() != ".md":
            raise ValueError(f"File is not a markdown file: {input_path}")
        return [input_path]

    if input_path.is_dir():
        files = sorted(input_path.rglob("*.md"))
        if not files:
            raise FileNotFoundError(f"No markdown files found in: {input_path}")
        return files

    raise ValueError(f"Input path does not exist: {input_path}")
