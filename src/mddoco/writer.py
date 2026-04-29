from pathlib import Path


def write_output(content: str, output_path: Path, filename: str) -> Path:
    """Write content to output_path/filename, creating directories as needed."""
    output_path.mkdir(parents=True, exist_ok=True)
    dest = output_path / filename
    dest.write_text(content, encoding="utf-8")
    return dest
