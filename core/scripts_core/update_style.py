import pathlib, re, html, shutil

BASE_DIRS = [pathlib.Path(__file__).parent / d for d in ("knowledge", "learn_output", "learn_tran")]
STYLE_BLOCK = """
<style id='miracle-theme'>
body{font-family:'Segoe UI',Arial,sans-serif;background:#f8f9fa;color:#212529;}
.navbar-brand{font-weight:600;}
footer{margin-top:4rem;padding-top:2rem;padding-bottom:2rem;border-top:1px solid #dee2e6;font-size:.9rem;color:#6c757d;text-align:center;}
.dark-toggle{cursor:pointer;}
body.dark{background:#1e1e1e;color:#f1f1f1;}
body.dark a{color:#0d6efd;}
body.dark .navbar{background:#343a40!important;}
</style>
<script id="dark-toggler">function toggleTheme(){var b=document.body;b.classList.toggle('dark');localStorage.setItem('theme',b.classList.contains('dark')?'dark':'light');}window.addEventListener('load',function(){if(localStorage.getItem('theme')==='dark'){document.body.classList.add('dark');}});</script>
"""
NAVBAR = """<nav class='navbar navbar-expand-lg navbar-light bg-light fixed-top'><div class='container-fluid'><a class='navbar-brand' href='#'>Knowledge Hub</a><button class='btn btn-sm btn-outline-primary dark-toggle' onclick='toggleTheme()'>🌙/☀️</button></div></nav><div style='height:58px'></div>"""
FOOTER = "<footer>© 2025 Knowledge Hub – Auto-generated</footer>"


def enhance_html(path: pathlib.Path):
    text = path.read_text(encoding='utf-8')
    if 'id=\'miracle-theme\'' in text:
        return False  # already enhanced
    # inject style before </head>
    text = re.sub(r'(</head>)', STYLE_BLOCK + r"\1", text, 1, flags=re.IGNORECASE)
    # inject navbar after <body>
    text = re.sub(r'(<body[^>]*>)', r"\1" + NAVBAR, text, 1, flags=re.IGNORECASE)
    # append footer before </body>
    text = re.sub(r'(</body>)', FOOTER + r"\1", text, 1, flags=re.IGNORECASE)
    path.write_text(text, encoding='utf-8')
    return True

def main():
    modified = 0
    for base in BASE_DIRS:
        if not base.exists():
            continue
        for html_file in base.rglob('*.html'):
            if enhance_html(html_file):
                modified += 1
    print(f"Enhanced {modified} HTML files.")

if __name__ == '__main__':
    main()