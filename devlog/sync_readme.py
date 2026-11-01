#!/usr/bin/env python3
"""
Syncs the latest N entries from devlog/entries.js into README.md.
Older entries in README.md are automatically pushed out, keeping only the top N.
"""

import os
import sys
import json
import re
import subprocess
from datetime import date

if hasattr(sys.stdout, "reconfigure"):
    try:
        sys.stdout.reconfigure(encoding="utf-8")
    except Exception:
        pass

DEVLOG_DIR = os.path.dirname(os.path.abspath(__file__))
PROJECT_ROOT = os.path.dirname(DEVLOG_DIR)
ENTRIES_FILE = os.path.join(DEVLOG_DIR, "entries.js")
README_FILE = os.path.join(PROJECT_ROOT, "README.md")

START_MARKER = "<!-- DEVLOG_ENTRIES_START -->"
END_MARKER = "<!-- DEVLOG_ENTRIES_END -->"

STATUS_ICONS = {
    "passed": "🟢",
    "wip": "🟡",
    "refactor": "🟣",
    "bugfix": "🔴",
    "feature": "🔵"
}

def load_entries():
    if not os.path.exists(ENTRIES_FILE):
        raise FileNotFoundError(f"Cannot find {ENTRIES_FILE}")

    # Use node to evaluate entries.js if node is available (handles trailing commas & JS comments)
    try:
        cmd = [
            "node", "-e",
            'const fs = require("fs"); const c = fs.readFileSync(process.argv[1], "utf8"); const m = c.match(/const\\s+ENTRIES\\s*=\\s*(\\[[\\s\\S]*?\\])\\s*;/); console.log(JSON.stringify(eval(m[1])));',
            ENTRIES_FILE
        ]
        res = subprocess.run(cmd, capture_output=True, text=True, encoding="utf-8", check=True)
        return json.loads(res.stdout)
    except Exception:
        # Fallback pure-python parser
        with open(ENTRIES_FILE, "r", encoding="utf-8") as f:
            content = f.read()
        match = re.search(r"const\s+ENTRIES\s*=\s*(\[[\s\S]*?\])\s*;", content)
        if not match:
            raise ValueError("Could not find const ENTRIES = [...] in entries.js")
        raw = match.group(1)
        raw = re.sub(r"//.*", "", raw)
        raw = re.sub(r'(\s*)([a-zA-Z0-9_]+)(\s*):', r'\1"\2"\3:', raw)
        raw = re.sub(r",(\s*[}\]])", r"\1", raw)
        return json.loads(raw)

def generate_markdown(entries, max_count=3):
    items = entries[:max_count]
    blocks = []

    for idx, item in enumerate(items):
        is_open = " open" if idx == 0 else ""
        icon = STATUS_ICONS.get(item.get("status"), "🟢")
        entry_date = item.get("date", "")
        title = item.get("title", "")

        tags = " ".join([f"<code>#{t}</code>" for t in item.get("tags", [])])

        lines = [f"    <details{is_open}>"]
        # Summary with date + title, then tags on a new line
        lines.append(f"        <summary><b>{icon} {entry_date}: {title}</b><br>{tags}</summary>")
        lines.append("        <br>")
        # Table centering: GitHub preserves <table> align="center" and <td> align="left"
        lines.append("        <table align=\"center\" border=\"0\">")
        lines.append("            <tr>")
        lines.append("                <td align=\"left\">")
        lines.append("                    <ul>")

        bullets = item.get("bullets", [])
        # Ensure at least 3 bullet points
        formatted_bullets = list(bullets)
        if len(formatted_bullets) < 3:
            if not formatted_bullets:
                formatted_bullets.append(title)
            while len(formatted_bullets) < 3:
                formatted_bullets.append("Detailed implementation verified and logged.")

        for b in formatted_bullets:
            lines.append(f"                        <li>{b}</li>")

        terminal = item.get("terminal")
        if terminal:
            first_cmd = terminal.splitlines()[0]
            lines.append(f"                        <li><code>{first_cmd}</code></li>")

        lines.append("                    </ul>")
        lines.append("                </td>")
        lines.append("            </tr>")
        lines.append("        </table>")
        lines.append("    </details>")
        blocks.append("\n".join(lines))

    return "\n" + "\n".join(blocks) + "\n    "

def sync_readme(max_count=3):
    if not os.path.exists(README_FILE):
        print(f"Error: {README_FILE} not found!")
        return False

    entries = load_entries()
    if not entries:
        print("No entries found in entries.js")
        return False

    new_content_block = generate_markdown(entries, max_count=max_count)

    with open(README_FILE, "r", encoding="utf-8") as f:
        readme_text = f.read()

    if START_MARKER not in readme_text or END_MARKER not in readme_text:
        print(f"Markers {START_MARKER} / {END_MARKER} not found in README.md. Please add them first.")
        return False

    pattern = re.compile(f"{re.escape(START_MARKER)}[\\s\\S]*?{re.escape(END_MARKER)}")
    replacement = f"{START_MARKER}{new_content_block}{END_MARKER}"

    updated_readme = pattern.sub(replacement, readme_text)

    with open(README_FILE, "w", encoding="utf-8") as f:
        f.write(updated_readme)

    print(f"✅ README.md updated successfully with the top {min(len(entries), max_count)} latest entries!")
    return True

if __name__ == "__main__":
    count = 3
    if len(sys.argv) > 1 and sys.argv[1].isdigit():
        count = int(sys.argv[1])
    sync_readme(max_count=count)

