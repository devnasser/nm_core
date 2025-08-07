import pathlib, re
base = pathlib.Path(__file__).parent / 'learn_output'
map_names = {
    'أحمد الماهر':'أحمد بن ناصر',
    'سارة العبقرية':'سارة بنت ناصر',
    'محمد النابغة':'محمد بن ناصر',
    'فاطمة الخارقة':'فاطمة بنت ناصر',
}
for path in base.rglob('*.md'):
    text = path.read_text(encoding='utf-8')
    original = text
    for old,new in map_names.items():
        text = text.replace(old,new)
    if text!=original:
        path.write_text(text, encoding='utf-8')
        print('Updated', path)