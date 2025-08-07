# Project Overview / نظرة عامة على المشروع

**English**

Welcome to the Smart Auto-Parts Marketplace – an internal, Laravel-powered Zero-Code platform crafted for rapid application generation.  This repository holds everything: infrastructure scripts, documentation, learning artefacts, and (soon) the Zero-Code source capable of generating 50 applications.

**Key Highlights**

- Tech Stack: PHP 8.3, Laravel 11+, SQLite (FTS5 + WAL), Livewire, Bootstrap 5 (CDN only), **No Node/NPM**.
- Knowledge Folders: learn_output (detailed), learn_tran (AI-ready), knowledge (mirror).
- Zero-Code Goal: Drag-&-Drop builder, dynamic scaffolding, one-click export, AI integration.
- Performance: Full-core autoscaling, row-cache, RAM-disk, µBus ≤ 1 ms.
- Documentation: Every readable file ships in md / html / pdf, bilingual (EN ↔ AR).
- Accessibility: Multi-language UI + Voice & Symbol support.

**Getting Started**

1. `git clone <repo>` then `cd workspace`.
2. Read `docs/ABOUT_DIRECTORIES.*` to explore the folder map.
3. Use `core/scripts_core/auto_bilingual_inject.py MyDoc.md` to add bilingual blocks.
4. Once the Zero-Code generator is ready run `php artisan migrate --seed`.

**Contact**  
Project Owner: **Nasser Alanazi** – dev.na@outlook.com – +966 50 848 0715.

---

## العربية

مرحبًا بك في منصة قطع الغيار الذكية – منصة **Zero-Code** مبنية على Laravel لإنشاء التطبيقات بسرعة. يحتوي هذا المستودع على كل ما تحتاجه من سكربتات للبنية التحتية، وثائق، مخرجات تعلّم، والكود المصدري الذي سيُنشئ لاحقًا 50 تطبيقًا.

**أبرز المميزات**

- حزمة التقنيات: PHP 8.3، Laravel 11+، SQLite (FTS5 + WAL)، Livewire، Bootstrap 5 (عن طريق CDN)، **بدون Node/NPM**.
- مجلدات المعرفة: learn_output (تفصيلية)، learn_tran (جاهزة للذكاء الاصطناعي)، knowledge (مرآة).
- هدف منصة Zero-Code: منشئ Drag-&-Drop، توليد ملفات ديناميكي، تصدير بنقرة، دمج ذكاء اصطناعي.
- الأداء: استغلال كامل للأنوية، Row-Cache، RAM-Disk، ناقل µBus أقل من 1 مللي ثانية.
- التوثيق: كل ملف قراءة متوفر بصيغ md / html / pdf وباللغتين.
- الوصول: واجهة متعددة اللغات + دعم صوتي ورموز.

**خطوات البدء**

1. `git clone <repo>` ثم `cd workspace`.
2. اقرأ `docs/ABOUT_DIRECTORIES.*` لمعرفة خريطة المجلدات.
3. استخدم السكربت `auto_bilingual_inject.py` لإضافة بلوكات ثنائية اللغة.
4. بعد تجهيز مولّد Zero-Code شغّل `php artisan migrate --seed` لإعداد البيئة.

**التواصل**  
مالك المشروع: **ناصر العنزي** – dev.na@outlook.com – +966 50 848 0715.
