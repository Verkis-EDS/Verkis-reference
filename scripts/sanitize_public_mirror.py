#!/usr/bin/env python3
from __future__ import annotations

import argparse
import re
import shutil
from pathlib import Path

TEXT_EXTENSIONS = {
    ".md", ".txt", ".yml", ".yaml", ".json", ".toml", ".ini",
    ".sh", ".py", ".js", ".ts", ".css", ".html", ".example",
}

BLOCKED_NAME_PATTERNS = [
    re.compile(r".*\.env(\..*)?$", re.I),
    re.compile(r".*secret.*", re.I),
    re.compile(r".*token.*", re.I),
    re.compile(r".*password.*", re.I),
    re.compile(r".*credential.*", re.I),
    re.compile(r".*private.*key.*", re.I),
    re.compile(r".*id_rsa.*", re.I),
    re.compile(r".*id_ed25519.*", re.I),
    re.compile(r".*\.pem$", re.I),
    re.compile(r".*\.key$", re.I),
    re.compile(r".*\.p12$", re.I),
    re.compile(r".*\.pfx$", re.I),
    re.compile(r".*wg.*\.conf$", re.I),
    re.compile(r".*wireguard.*", re.I),
]

REDACTIONS = [
    (re.compile(r"\b10(?:\.\d{1,3}){3}\b"), "10.x.x.x"),
    (re.compile(r"\b172\.(?:1[6-9]|2\d|3[0-1])(?:\.\d{1,3}){2}\b"), "172.16.x.x"),
    (re.compile(r"\b192\.168(?:\.\d{1,3}){2}\b"), "192.168.x.x"),
    (re.compile(r"(?i)(token|api[_-]?key|secret|password|passwd|private[_-]?key)\s*[:=]\s*['\"]?[^'\"\s]+"), r"\1=<REDACTED>"),
    (re.compile(r"\bglpat-[A-Za-z0-9_\-]{20,}\b"), "glpat-<REDACTED>"),
    (re.compile(r"\bgh[pousr]_[A-Za-z0-9_]{30,}\b"), "ghx_<REDACTED>"),
    (re.compile(r"-----BEGIN [A-Z ]*PRIVATE KEY-----.*?-----END [A-Z ]*PRIVATE KEY-----", re.S), "<REDACTED_PRIVATE_KEY_BLOCK>"),
    (re.compile(r"(?i)(PrivateKey|PresharedKey)\s*=\s*[A-Za-z0-9+/=]{20,}"), r"\1 = <REDACTED>"),
]


def is_blocked(path: Path) -> bool:
    parts = [p.lower() for p in path.parts]
    if ".git" in parts or "__pycache__" in parts or "node_modules" in parts:
        return True
    return any(pattern.match(path.name) for pattern in BLOCKED_NAME_PATTERNS)


def is_text_file(path: Path) -> bool:
    return path.suffix.lower() in TEXT_EXTENSIONS or path.name.upper() in {"README", "LICENSE"}


def sanitize_text(text: str) -> str:
    for pattern, replacement in REDACTIONS:
        text = pattern.sub(replacement, text)
    return text


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--source", required=True)
    parser.add_argument("--dest", required=True)
    parser.add_argument("--strict", action="store_true")
    args = parser.parse_args()

    source = Path(args.source).expanduser().resolve()
    dest = Path(args.dest).expanduser().resolve()

    if not source.exists():
        raise SystemExit(f"Source does not exist: {source}")

    if dest.exists():
        shutil.rmtree(dest)
    dest.mkdir(parents=True, exist_ok=True)

    report = ["# Sanitization Report", ""]
    copied = blocked = skipped = 0

    for path in source.rglob("*"):
        if path.is_dir():
            continue

        rel = path.relative_to(source)

        if is_blocked(path) or any(is_blocked(Path(part)) for part in rel.parts):
            blocked += 1
            report.append(f"- BLOCKED: `{rel}`")
            continue

        if not is_text_file(path):
            skipped += 1
            report.append(f"- SKIPPED non-text: `{rel}`")
            continue

        clean = sanitize_text(path.read_text(encoding="utf-8", errors="replace"))

        if args.strict and re.search(r"(?i)(password\s*[:=]|token\s*[:=]|secret\s*[:=]|PRIVATE KEY)", clean):
            blocked += 1
            report.append(f"- BLOCKED suspicious content after redaction: `{rel}`")
            continue

        target = dest / rel
        target.parent.mkdir(parents=True, exist_ok=True)
        target.write_text(clean, encoding="utf-8")
        copied += 1
        report.append(f"- COPIED sanitized: `{rel}`")

    report += ["", "## Summary", "", f"- Copied: {copied}", f"- Blocked: {blocked}", f"- Skipped: {skipped}"]
    (dest / "SANITIZATION_REPORT.md").write_text("\n".join(report), encoding="utf-8")
    print(f"Sanitization complete. copied={copied} blocked={blocked} skipped={skipped}")


if __name__ == "__main__":
    main()
