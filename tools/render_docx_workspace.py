from __future__ import annotations

import os
import runpy
import shutil
import sys
import tempfile
import uuid
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
TMP_ROOT = ROOT / ".codex-tmp" / "render-temp"
RENDERER = (
    Path("C:/Users/LOQ/.codex/plugins/cache/openai-primary-runtime")
    / "documents"
    / "26.601.10930"
    / "skills"
    / "documents"
    / "render_docx.py"
)


class WorkspaceTemporaryDirectory:
    def __init__(self, suffix: str | None = None, prefix: str | None = None, dir: str | None = None, ignore_cleanup_errors: bool = False):
        suffix = suffix or ""
        prefix = prefix or "tmp"
        base = Path(dir) if dir else TMP_ROOT
        base.mkdir(parents=True, exist_ok=True)
        self.name = str(base / f"{prefix}{uuid.uuid4().hex}{suffix}")
        os.makedirs(self.name, exist_ok=False)
        self._ignore_cleanup_errors = ignore_cleanup_errors

    def __enter__(self) -> str:
        return self.name

    def __exit__(self, exc_type, exc, tb) -> None:
        shutil.rmtree(self.name, ignore_errors=True)

    def cleanup(self) -> None:
        shutil.rmtree(self.name, ignore_errors=True)


def main() -> None:
    if not RENDERER.exists():
        raise SystemExit(f"Renderer not found: {RENDERER}")
    TMP_ROOT.mkdir(parents=True, exist_ok=True)
    tempfile.TemporaryDirectory = WorkspaceTemporaryDirectory
    os.environ["TEMP"] = str(TMP_ROOT)
    os.environ["TMP"] = str(TMP_ROOT)
    os.environ["TMPDIR"] = str(TMP_ROOT)
    sys.argv = [str(RENDERER), *sys.argv[1:]]
    runpy.run_path(str(RENDERER), run_name="__main__")


if __name__ == "__main__":
    main()
