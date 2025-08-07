import os, sys, glob, pathlib
try:
    import markdown
except ImportError:
    print("markdown module missing, please run: pip install markdown")
    sys.exit(1)
base = pathlib.Path(__file__).parent / 'learn_output'
for path in base.rglob('*.md'):
    md_text = path.read_text(encoding='utf-8')
    body = markdown.markdown(md_text, extensions=['fenced_code', 'tables'])
    title = path.stem
    html = f"""<!DOCTYPE html><html lang='en'><head><meta charset='utf-8'><meta name='viewport' content='width=device-width,initial-scale=1'>
    <title>{title}</title><link href='https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css' rel='stylesheet'></head>
    <body class='container py-4'>{body}</body></html>"""
    html_path = path.with_suffix('.html')
    html_path.write_text(html, encoding='utf-8')
    print('Converted', html_path)