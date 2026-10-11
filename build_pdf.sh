#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BUILD_DIR="$ROOT/.build"
mkdir -p "$BUILD_DIR"

uv run --with pypandoc-binary --with weasyprint python - "$ROOT" "$BUILD_DIR" <<'PY'
from pathlib import Path
import subprocess
import sys

import pypandoc
from weasyprint import HTML

root = Path(sys.argv[1])
build_dir = Path(sys.argv[2])
source = root / "article.md"
css = root / "article.css"
html = build_dir / "human-finds-a-way.html"
pdf = root / "human-finds-a-way.pdf"

subprocess.run(
    [
        pypandoc.get_pandoc_path(),
        str(source),
        "--from=markdown+smart",
        "--to=html5",
        "--standalone",
        "--embed-resources",
        f"--css={css}",
        "--metadata=title-meta:Human Finds a Way",
        "--output",
        str(html),
    ],
    check=True,
)
HTML(filename=str(html), base_url=str(root)).write_pdf(str(pdf))
print(pdf)
PY
