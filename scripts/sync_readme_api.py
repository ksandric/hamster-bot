"""Встраивает API.md в README.md между маркерами API:START / API:END.

Запуск из корня репозитория: python scripts/sync_readme_api.py
Проверка без записи (для CI):  python scripts/sync_readme_api.py --check
"""
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
README = ROOT / "README.md"
API = ROOT / "API.md"

START = "<!-- API:START -->"
END = "<!-- API:END -->"
NOTE = "<!-- Содержимое между маркерами генерируется из API.md (scripts/sync_readme_api.py). Правьте API.md, а не этот блок. -->"


def render_api(text: str) -> str:
    """Понижает уровень заголовков на 1 (кроме блоков кода) и убирает верхний «# API»."""
    lines = text.replace("\r\n", "\n").split("\n")
    out = []
    in_fence = False
    dropped_title = False
    for line in lines:
        if re.match(r"^\s*(```|~~~)", line):
            in_fence = not in_fence
        elif not in_fence:
            if not dropped_title and re.match(r"^# ", line):
                dropped_title = True
                continue
            if re.match(r"^#{1,5} ", line):
                line = "#" + line
        out.append(line)
    return "\n".join(out).strip("\n")


def build(readme_text: str, api_text: str) -> str:
    pattern = re.compile(re.escape(START) + r".*?" + re.escape(END), re.S)
    if not pattern.search(readme_text):
        raise SystemExit(f"В README.md не найдены маркеры {START} / {END}")
    block = f"{START}\n{NOTE}\n\n{render_api(api_text)}\n\n{END}"
    return pattern.sub(lambda _: block, readme_text, count=1)


def main() -> int:
    readme_text = README.read_text(encoding="utf-8").replace("\r\n", "\n")
    new_text = build(readme_text, API.read_text(encoding="utf-8"))
    if new_text == readme_text:
        print("README.md уже актуален")
        return 0
    if "--check" in sys.argv:
        print("README.md не соответствует API.md: запустите scripts/sync_readme_api.py")
        return 1
    README.write_text(new_text, encoding="utf-8", newline="\n")
    print("README.md обновлён из API.md")
    return 0


if __name__ == "__main__":
    sys.exit(main())
