#!/usr/bin/env python3
"""
Ubah publications.bib menjadi daftar Markdown.
Pemakaian:
    python3 scripts/bib2md.py publications.bib
Salin keluarannya ke bagian "### Selected" di
content/publications/_index.md
"""
import re, sys

def parse_bib(text):
    entries = []
    for block in re.findall(r'@\w+\s*\{(.*?)\n\}', text, re.S):
        block = block + '\n'
        fields = {}
        # key baris pertama
        first = block.split(',', 1)
        for m in re.finditer(r'(\w+)\s*=\s*[{"](.+?)[}"]\s*,?\s*\n', block, re.S):
            fields[m.group(1).lower()] = ' '.join(m.group(2).split())
        entries.append(fields)
    return entries

def fmt_authors(a):
    # "Last, First and Last, First" -> "First Last, First Last"
    out = []
    for name in a.split(' and '):
        if ',' in name:
            last, first = [x.strip() for x in name.split(',', 1)]
            out.append(f"{first} {last}")
        else:
            out.append(name.strip())
    return ', '.join(out)

def main():
    path = sys.argv[1] if len(sys.argv) > 1 else 'publications.bib'
    entries = parse_bib(open(path, encoding='utf-8').read())
    # urut terbaru dulu
    entries.sort(key=lambda e: e.get('year', '0'), reverse=True)
    for e in entries:
        authors = fmt_authors(e.get('author', ''))
        authors = authors.replace('Bangkit Gotama', '**Bangkit Gotama**')
        venue = e.get('journal') or e.get('booktitle') or ''
        year = e.get('year', '')
        title = e.get('title', '')
        line = f'- {authors}. "{title}." *{venue}*, {year}.'
        if e.get('doi'):
            line += f" [DOI](https://doi.org/{e['doi']})"
        print(line)

if __name__ == '__main__':
    main()
