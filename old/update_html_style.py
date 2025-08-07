import pathlib, re, html
base = pathlib.Path(__file__).parent / 'learn_output'
custom_css = """
<style id='custom-style'>
body{background:linear-gradient(135deg,#f8fafc,#e8ecf1);font-family:'Segoe UI',Arial,sans-serif;color:#212529;}
h1,h2,h3,h4{color:#0d6efd;margin-top:1.25rem;margin-bottom:0.75rem;font-weight:600;}
.card{box-shadow:0 4px 8px rgba(0,0,0,.05);border:1px solid #e5e9ec;border-radius:.5rem;margin:1rem 0;padding:1rem;background:#fff;}
pre,code{background:#f1f3f5;border-radius:.25rem;padding:.25rem .5rem;font-size:85%;}
a{color:#0d6efd;text-decoration:none;}
a:hover{text-decoration:underline;}
</style>
"""
html_files = list(base.rglob('*.html'))
links = []
for path in html_files:
    text = path.read_text(encoding='utf-8')
    if 'id=\'custom-style\'' not in text:
        text = re.sub(r'(</head>)', custom_css + r'\1', text, count=1, flags=re.IGNORECASE)
        path.write_text(text, encoding='utf-8')
    rel = path.relative_to(base).as_posix()
    links.append(rel)
# build index.html
index_body = "<h1 class='mb-4'>Learn Output Portal</h1>\n<p>Below are all generated pages with enriched styles and updated content.</p>\n<div class='list-group'>\n" + "\n".join([f"<a class='list-group-item list-group-item-action' href='{html.escape(l)}' target='_blank'>{html.escape(l)}</a>" for l in sorted(links)]) + "\n</div>"
index_html = f"""<!DOCTYPE html><html lang='en'><head><meta charset='utf-8'><meta name='viewport' content='width=device-width,initial-scale=1'>
<title>Learn Output Portal</title>
<link href='https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css' rel='stylesheet'>
{custom_css}
</head><body class='container py-5'>
{index_body}
</body></html>"""
(base / 'index.html').write_text(index_html, encoding='utf-8')
print('Updated styles and generated index.html')