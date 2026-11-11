"""Собирает статический index.html (для GitHub Pages) из README.md.

Контент рендерится заранее, поэтому поисковики видят его без JavaScript.
Запуск из корня репозитория: python scripts/build_index.py
Зависимость: pip install markdown-it-py
"""
import html
import re
import sys
from datetime import datetime, timezone
from pathlib import Path

from markdown_it import MarkdownIt

ROOT = Path(__file__).resolve().parent.parent
README = ROOT / "README.md"
TEMPLATE = ROOT / "scripts" / "index.template.html"
INDEX = ROOT / "index.html"
SITEMAP = ROOT / "sitemap.xml"
ROBOTS = ROOT / "robots.txt"

SITE_URL = "https://ksandric.github.io/hamster-bot/"
REPO_BLOB = "https://github.com/ksandric/hamster-bot/blob/master/"


def github_slug(text: str) -> str:
    text = html.unescape(re.sub(r"<[^>]+>", "", text)).strip().lower()
    text = re.sub(r"[^\w\- ]", "", text)  # \w в Python включает буквы любых алфавитов, цифры и «_»
    return text.replace(" ", "-")


def add_heading_ids(body: str) -> str:
    used = {}

    def repl(m):
        level, attrs, inner = m.group(1), m.group(2), m.group(3)
        base = github_slug(inner)
        n = used.get(base, 0)
        used[base] = n + 1
        return f'<h{level}{attrs} id="{base if not n else f"{base}-{n}"}">{inner}</h{level}>'

    return re.sub(r"<h([1-6])((?:\s[^>]*)?)>(.*?)</h\1>", repl, body, flags=re.S)


def fix_links(body: str) -> str:
    """Относительные ссылки ведут на файлы в GitHub, внешние открываются в новой вкладке."""
    def repl(m):
        before, href, after = m.group(1), m.group(2), m.group(3)
        if href.startswith("#") or href.startswith("mailto:"):
            return m.group(0)
        if re.match(r"^(https?:)?//", href):
            extra = "" if "target=" in before + after else ' target="_blank" rel="noopener"'
            return f'<a {before}href="{href}"{after}{extra}>'
        url = REPO_BLOB + re.sub(r"^\./", "", href)
        return f'<a {before}href="{url}"{after} target="_blank" rel="noopener">'

    return re.sub(r'<a\s+([^>]*?)href="([^"]*)"([^>]*)>', repl, body)


def lazy_images(body: str) -> str:
    """Все изображения, кроме первого (логотип), грузятся лениво."""
    count = 0

    def repl(m):
        nonlocal count
        count += 1
        tag = m.group(0)
        if count == 1 or "loading=" in tag:
            return tag
        return tag[:-1].rstrip("/").rstrip() + ' loading="lazy" decoding="async">'

    return re.sub(r"<img\b[^>]*>", repl, body)


def render(md_text: str) -> str:
    md = MarkdownIt("commonmark", {"html": True}).enable(["table", "strikethrough"])
    body = md.render(md_text)
    return lazy_images(fix_links(add_heading_ids(body)))


def write_if_changed(path: Path, text: str) -> bool:
    if path.exists() and path.read_text(encoding="utf-8").replace("\r\n", "\n") == text:
        return False
    path.write_text(text, encoding="utf-8", newline="\n")
    return True


def main() -> int:
    md_text = README.read_text(encoding="utf-8").replace("\r\n", "\n")
    page = TEMPLATE.read_text(encoding="utf-8").replace("\r\n", "\n").replace("<!-- CONTENT -->", render(md_text).strip())

    if "--check" in sys.argv:
        current = INDEX.read_text(encoding="utf-8").replace("\r\n", "\n") if INDEX.exists() else ""
        if current != page:
            print("index.html устарел: запустите python scripts/build_index.py")
            return 1
        print("index.html актуален")
        return 0

    changed = write_if_changed(INDEX, page)

    # lastmod обновляем только при реальном изменении страницы, чтобы не создавать лишних коммитов
    if changed or not SITEMAP.exists():
        today = datetime.now(timezone.utc).strftime("%Y-%m-%d")
        write_if_changed(SITEMAP, (
            '<?xml version="1.0" encoding="UTF-8"?>\n'
            '<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">\n'
            f"  <url>\n    <loc>{SITE_URL}</loc>\n    <lastmod>{today}</lastmod>\n"
            "    <changefreq>weekly</changefreq>\n    <priority>1.0</priority>\n  </url>\n"
            "</urlset>\n"
        ))
    write_if_changed(ROBOTS, f"User-agent: *\nAllow: /\n\nSitemap: {SITE_URL}sitemap.xml\n")

    print("index.html обновлён" if changed else "index.html уже актуален")
    return 0


if __name__ == "__main__":
    sys.exit(main())
