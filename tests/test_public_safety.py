import os
import subprocess
import tempfile
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]

class PublicSafetyTests(unittest.TestCase):
    def scan(self, text):
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp)
            subprocess.run(["git", "init", "-q", tmp], check=True)
            (root / "candidate.md").write_text(text)
            (root / "scripts").mkdir()
            (root / "scripts/noop.sh").write_text("#!/usr/bin/env bash\ntrue\n")
            return subprocess.run(["bash", str(ROOT / "scripts/verify_public_repo.sh")], cwd=tmp, capture_output=True, text=True)

    def test_secret_is_rejected_without_echoing_it(self):
        value = "".join(["gl", "pat-", "SyntheticFixture" * 3])
        result = self.scan(value)
        self.assertNotEqual(result.returncode, 0)
        self.assertIn("candidate.md", result.stdout)
        self.assertNotIn(value, result.stdout + result.stderr)

    def test_all_private_ranges_rejected(self):
        for octets in [(10, 2, 3, 4), (172, 20, 3, 4), (192, 168, 3, 4)]:
            with self.subTest(octets=octets):
                result = self.scan(".".join(map(str, octets)))
                self.assertNotEqual(result.returncode, 0)
                self.assertIn("private IP references", result.stdout)

    def test_placeholder_passes(self):
        self.assertEqual(self.scan("Use <SERVER_IP> and a credential file outside Git.").returncode, 0)

    def test_sanitizer_does_not_delete_existing_destination(self):
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp); source = root / "source"; dest = root / "dest"
            source.mkdir(); dest.mkdir(); (dest / "keep.md").write_text("unique")
            result = subprocess.run(["python3", str(ROOT / "scripts/sanitize_public_mirror.py"), "--source", str(source), "--dest", str(dest), "--strict"], capture_output=True)
            self.assertNotEqual(result.returncode, 0)
            self.assertEqual((dest / "keep.md").read_text(), "unique")

    def test_personality_destination_symlink_is_rejected(self):
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp)
            subprocess.run(["git", "init", "-q", tmp], check=True)
            (root / "PERSONALITY.md").write_text("public personality")
            subprocess.run(["git", "add", "PERSONALITY.md"], cwd=tmp, check=True)
            (root / "outside.md").write_text("keep")
            (root / "docs/reference").mkdir(parents=True)
            (root / "docs/reference/personality.md").symlink_to(root / "outside.md")
            result = subprocess.run(["bash", str(ROOT / "scripts/sync_personality.sh")], cwd=tmp, capture_output=True)
            self.assertNotEqual(result.returncode, 0)
            self.assertEqual((root / "outside.md").read_text(), "keep")

    def test_allowlisted_source_symlink_rejected_before_copy(self):
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp); common = root / "common"; repo = root / "repo"
            common.mkdir(); repo.mkdir()
            for path in [common, repo]:
                subprocess.run(["git", "init", "-q", str(path)], check=True)
            (root / "outside.md").write_text("must not be exported")
            (common / "RULES.md").symlink_to(root / "outside.md")
            subprocess.run(["git", "add", "RULES.md"], cwd=common, check=True)
            subprocess.run(["git", "-c", "user.name=Test", "-c", "user.email=test@example.org", "commit", "-qm", "fixture"], cwd=common, check=True)
            env = dict(os.environ, REPO_DIR=str(repo), NAS_COMMON=str(common), PUSH="0")
            result = subprocess.run(["bash", str(ROOT / "scripts/public_mirror_sync.sh")], env=env, capture_output=True, text=True)
            self.assertNotEqual(result.returncode, 0)
            self.assertIn("Source symlink rejected", result.stderr)
            self.assertFalse((repo / "docs").exists())

    def test_symlink_cannot_export_outside_allowlist(self):
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp); source = root / "source"; source.mkdir()
            (root / "private.md").write_text("not an export input")
            (source / "escape.md").symlink_to(root / "private.md")
            result = subprocess.run(["python3", str(ROOT / "scripts/sanitize_public_mirror.py"), "--source", str(source), "--dest", str(root / "dest"), "--strict"], capture_output=True)
            self.assertNotEqual(result.returncode, 0)
            self.assertFalse((root / "dest/escape.md").exists())

if __name__ == "__main__":
    unittest.main()
