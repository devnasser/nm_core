# 📋 وثائق API - نظام اعجوبة الأساسي

<div align="center">

![API Version](https://img.shields.io/badge/API-v2.0-blue.svg)
![Status](https://img.shields.io/badge/Status-Stable-green.svg)
![Coverage](https://img.shields.io/badge/Coverage-95%25-brightgreen.svg)

**مرجع شامل لواجهة برمجة التطبيقات**

</div>

---

## 🎯 نظرة عامة

تقدم واجهة برمجة التطبيقات لنظام اعجوبة مجموعة شاملة من الدوال والأدوات لتطوير تطبيقات ويب متقدمة بتصميم أنيق وأداء عالي.

### 📦 الخصائص الرئيسية

- **⚡ أداء خارق**: محسن للسرعة والكفاءة
- **🎨 تصميم متقدم**: تأثيرات CSS وحركات سلسة
- **📱 تصميم متجاوب**: يعمل على جميع الأجهزة
- **🔧 قابلية التخصيص**: إعدادات مرنة ومتنوعة
- **🛡️ موثوق**: معالجة شاملة للأخطاء

---

## 🚀 البدء السريع

### التثبيت والإعداد

```html
<!-- إضافة النظام لصفحتك -->
<link rel="stylesheet" href="src/styles/main.css">
<script src="src/scripts/core.js"></script>
```

### الاستخدام الأساسي

```javascript
// النظام يتم تهيئته تلقائياً
// يمكنك الوصول إليه عبر:
console.log(NMCore.version); // "2.0.0"

// أو استخدام API المبسط:
nm.notify('مرحباً بك!'); // إظهار إشعار
```

---

## 📚 الوحدات الرئيسية

### 1. النظام الأساسي (Core System)

#### `NMCore`

النظام الرئيسي الذي يدير جميع الوظائف والمكونات.

```javascript
const core = NMCore;

// الخصائص الأساسية
core.version          // إصدار النظام
core.debug           // وضع التطوير
core.config          // الإعدادات
core.support         // دعم المتصفح
```

#### `NMCore.init()`

تهيئة النظام يدوياً (يتم تلقائياً عند التحميل).

```javascript
NMCore.init();
```

**القيمة المرجعة:** `void`

### 2. إدارة الإعدادات

#### `NMCore.config`

كائن الإعدادات الرئيسي للنظام.

```javascript
const config = {
  animations: {
    duration: 300,        // مدة الحركة بالمللي ثانية
    easing: 'ease-in-out', // نوع التسارع
    delay: 0              // التأخير
  },
  effects: {
    particles: true,      // تفعيل الجسيمات
    parallax: true,       // تفعيل المنظور
    smooth_scroll: true   // التمرير السلس
  },
  performance: {
    gpu_acceleration: true, // تسارع الرسوميات
    reduce_motion: false,   // تقليل الحركة
    lazy_loading: true      // التحميل التدريجي
  }
};
```

### 3. واجهة برمجة التطبيقات المبسطة

#### `nm.notify(message, type, duration)`

إظهار إشعار للمستخدم.

**المعاملات:**
- `message` (string): نص الإشعار
- `type` (string): نوع الإشعار - `'info'`, `'success'`, `'warning'`, `'error'`
- `duration` (number): مدة الإظهار بالمللي ثانية (افتراضي: 3000)

```javascript
// أمثلة
nm.notify('تم الحفظ بنجاح!', 'success');
nm.notify('خطأ في البيانات', 'error', 5000);
nm.notify('معلومة مهمة', 'info');
```

#### `nm.updateConfig(newConfig)`

تحديث إعدادات النظام.

**المعاملات:**
- `newConfig` (object): الإعدادات الجديدة

```javascript
nm.updateConfig({
  animations: { duration: 500 },
  effects: { particles: false }
});
```

#### `nm.getSystemInfo()`

الحصول على معلومات النظام.

**القيمة المرجعة:** `object`

```javascript
const info = nm.getSystemInfo();
console.log(info);
// {
//   version: "2.0.0",
//   support: { css_variables: true, ... },
//   config: { ... },
//   viewport: { width: 1920, height: 1080 },
//   userAgent: "...",
//   online: true
// }
```

---

## 🎨 فئات CSS المتقدمة

### البطاقات والحاويات

#### `.nm-card`

بطاقة أساسية مع تأثيرات حديثة.

```html
<div class="nm-card">
  محتوى البطاقة
</div>
```

**الخصائص:**
- خلفية بيضاء شفافة
- حواف مدورة (15px)
- ظل متدرج
- تأثير هوفر تلقائي

#### `.nm-card-gradient`

بطاقة بخلفية متدرجة.

```html
<div class="nm-card nm-card-gradient">
  بطاقة ملونة
</div>
```

### الأزرار المتطورة

#### `.nm-btn`

زر أساسي مع تأثيرات متقدمة.

```html
<button class="nm-btn nm-btn-primary">
  اضغط هنا
</button>
```

**الأنواع المتاحة:**
- `.nm-btn-primary`: اللون الرئيسي
- `.nm-btn-secondary`: اللون الثانوي  
- `.nm-btn-accent`: لون التمييز

### التخطيط والشبكة

#### `.nm-container`

حاوية محدودة العرض (1200px).

```html
<div class="nm-container">
  المحتوى الرئيسي
</div>
```

#### `.nm-grid`

شبكة مرنة للتخطيط.

```html
<div class="nm-grid nm-grid-3">
  <div>عنصر 1</div>
  <div>عنصر 2</div>
  <div>عنصر 3</div>
</div>
```

**الأنواع:**
- `.nm-grid-2`: عمودين
- `.nm-grid-3`: ثلاثة أعمدة
- `.nm-grid-4`: أربعة أعمدة

#### `.nm-flex`

حاوية مرنة مع Flexbox.

```html
<div class="nm-flex nm-flex-center">
  محتوى وسط الصفحة
</div>
```

**الأنواع:**
- `.nm-flex-center`: توسيط العناصر
- `.nm-flex-between`: توزيع متباعد
- `.nm-flex-column`: ترتيب عمودي

### النصوص والألوان

#### فئات النصوص

```html
<p class="nm-text-center">نص في الوسط</p>
<p class="nm-text-primary">نص بالون الرئيسي</p>
<p class="nm-text-gradient">نص بتدرج لوني</p>
```

### التأثيرات البصرية

#### `.nm-glow`

تأثير التوهج.

```html
<div class="nm-card nm-glow">
  بطاقة متوهجة
</div>
```

#### `.nm-blur`

تأثير الضبابية (Blur).

```html
<div class="nm-blur">
  خلفية ضبابية
</div>
```

#### `.nm-glass`

تأثير الزجاج (Glassmorphism).

```html
<div class="nm-glass">
  تأثير زجاجي عصري
</div>
```

### الحركات والتأثيرات

#### `.nm-animate-fadeIn`

ظهور تدريجي.

```html
<div class="nm-animate-fadeIn">
  سيظهر تدريجياً
</div>
```

#### `.nm-animate-slideIn`

انزلاق من الجانب.

```html
<div class="nm-animate-slideIn">
  سينزلق للداخل
</div>
```

#### `.nm-animate-pulse`

تأثير النبض.

```html
<div class="nm-animate-pulse">
  نبضات مستمرة
</div>
```

#### `.nm-animate-rainbow`

تدرج ألوان متحرك.

```html
<h1 class="nm-animate-rainbow">
  عنوان بألوان قوس قزح
</h1>
```

---

## 🔧 متغيرات CSS المخصصة

### الألوان الأساسية

```css
:root {
  --nm-primary: #ff6b6b;      /* اللون الرئيسي */
  --nm-secondary: #4ecdc4;    /* اللون الثانوي */
  --nm-accent: #ffd93d;       /* لون التمييز */
  --nm-dark: #2c3e50;         /* اللون الداكن */
  --nm-light: #ecf0f1;        /* اللون الفاتح */
}
```

### التدرجات

```css
:root {
  --nm-gradient-1: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  --nm-gradient-2: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
  --nm-gradient-3: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
}
```

### الظلال

```css
:root {
  --nm-shadow-light: 0 5px 15px rgba(0, 0, 0, 0.1);
  --nm-shadow-medium: 0 10px 30px rgba(0, 0, 0, 0.2);
  --nm-shadow-heavy: 0 20px 60px rgba(0, 0, 0, 0.4);
}
```

### الانتقالات

```css
:root {
  --nm-transition-fast: 0.2s ease;
  --nm-transition-medium: 0.4s ease;
  --nm-transition-slow: 0.8s ease;
}
```

---

## 📱 التصميم المتجاوب

النظام يدعم التصميم المتجاوب تلقائياً مع نقاط توقف محددة:

### نقاط التوقف

| الجهاز | العرض | الوصف |
|---------|--------|-------|
| Mobile | ≤ 480px | الهواتف الصغيرة |
| Tablet | ≤ 768px | الأجهزة اللوحية |
| Desktop | > 768px | أجهزة سطح المكتب |

### تخصيص نقاط التوقف

```css
/* هاتف صغير */
@media (max-width: 480px) {
  .nm-custom {
    font-size: 14px;
  }
}

/* جهاز لوحي */
@media (max-width: 768px) {
  .nm-grid-3 {
    grid-template-columns: 1fr;
  }
}
```

---

## 🎭 الأحداث والتفاعل

### أحداث النظام

النظام يرسل أحداث مخصصة يمكن الاستماع إليها:

```javascript
// حدث تهيئة النظام
document.addEventListener('nmcore:ready', (event) => {
  console.log('النظام جاهز!', event.detail);
});

// حدث تغيير الإعدادات
document.addEventListener('nmcore:config-updated', (event) => {
  console.log('تم تحديث الإعدادات:', event.detail);
});

// حدث ظهور العنصر
document.addEventListener('nmcore:element-visible', (event) => {
  console.log('عنصر ظهر في الشاشة:', event.target);
});
```

### تخصيص الأحداث

```javascript
// إرسال حدث مخصص
NMCore.dispatchEvent('custom-event', {
  message: 'حدث مخصص',
  timestamp: Date.now()
});

// الاستماع للحدث
document.addEventListener('nmcore:custom-event', (event) => {
  console.log(event.detail.message);
});
```

---

## 🔍 تتبع الأداء

### مراقبة الأداء

```javascript
// تفعيل مراقبة الأداء
NMCore.performance.start();

// الحصول على إحصائيات
const stats = NMCore.performance.getStats();
console.log('إحصائيات الأداء:', stats);
```

### تحسين الأداء

```javascript
// تفعيل التحسينات
nm.updateConfig({
  performance: {
    gpu_acceleration: true,
    lazy_loading: true,
    reduce_motion: false
  }
});
```

---

## 🐛 معالجة الأخطاء

### تسجيل الأخطاء

```javascript
// تفعيل وضع التطوير
NMCore.debug = true;

// رسائل مخصصة
NMCore.log('معلومة مفيدة');
NMCore.warn('تحذير مهم');
NMCore.error('خطأ خطير');
```

### معالج الأخطاء العالمي

```javascript
// معالج مخصص للأخطاء
window.addEventListener('nmcore:error', (event) => {
  console.error('خطأ في النظام:', event.detail);
  
  // إرسال تقرير الخطأ للخادم
  fetch('/api/error-report', {
    method: 'POST',
    body: JSON.stringify(event.detail)
  });
});
```

---

## 🌐 التدويل (i18n)

### إعداد اللغات

```javascript
// تحديد اللغة
NMCore.setLanguage('ar'); // العربية
NMCore.setLanguage('en'); // الإنجليزية

// إضافة ترجمات مخصصة
NMCore.addTranslations('ar', {
  'hello': 'مرحباً',
  'goodbye': 'وداعاً'
});

// استخدام الترجمة
const greeting = NMCore.t('hello'); // "مرحباً"
```

### نص تلقائي

```html
<!-- HTML مع ترجمة تلقائية -->
<p data-i18n="hello">Hello</p>
<button data-i18n="save">Save</button>
```

---

## 📊 أمثلة متقدمة

### مثال 1: بطاقة تفاعلية

```html
<div class="nm-card nm-animate-on-scroll" onclick="cardClick(this)">
  <h3 class="nm-text-gradient">عنوان البطاقة</h3>
  <p>وصف البطاقة مع تأثيرات جميلة</p>
  <button class="nm-btn nm-btn-primary">اقرأ المزيد</button>
</div>

<script>
function cardClick(card) {
  nm.notify('تم النقر على البطاقة!', 'info');
  card.classList.add('nm-glow');
}
</script>
```

### مثال 2: نموذج متقدم

```html
<form class="nm-card" onsubmit="handleSubmit(event)">
  <h2 class="nm-text-center">نموذج التواصل</h2>
  
  <div class="nm-flex nm-flex-column">
    <label>الاسم:</label>
    <input type="text" class="nm-input" required>
  </div>
  
  <div class="nm-flex nm-flex-column">
    <label>الرسالة:</label>
    <textarea class="nm-input" rows="4" required></textarea>
  </div>
  
  <button type="submit" class="nm-btn nm-btn-primary">
    إرسال
  </button>
</form>

<script>
function handleSubmit(event) {
  event.preventDefault();
  
  // محاكاة إرسال البيانات
  nm.notify('جاري الإرسال...', 'info');
  
  setTimeout(() => {
    nm.notify('تم الإرسال بنجاح!', 'success');
  }, 2000);
}
</script>
```

### مثال 3: معرض صور

```html
<div class="nm-grid nm-grid-3">
  <div class="nm-card nm-animate-on-scroll" style="animation-delay: 0.1s">
    <img src="image1.jpg" alt="صورة 1" class="nm-image">
  </div>
  <div class="nm-card nm-animate-on-scroll" style="animation-delay: 0.2s">
    <img src="image2.jpg" alt="صورة 2" class="nm-image">
  </div>
  <div class="nm-card nm-animate-on-scroll" style="animation-delay: 0.3s">
    <img src="image3.jpg" alt="صورة 3" class="nm-image">
  </div>
</div>

<style>
.nm-image {
  width: 100%;
  height: 200px;
  object-fit: cover;
  border-radius: 10px;
  transition: var(--nm-transition-medium);
}

.nm-image:hover {
  transform: scale(1.05);
}
</style>
```

---

## 📋 قائمة مرجعية للمطورين

### ✅ قبل البدء

- [ ] تأكد من تحميل ملفات CSS و JS
- [ ] فحص دعم المتصفح
- [ ] تحديد الإعدادات المطلوبة
- [ ] اختبار على أجهزة مختلفة

### ✅ أثناء التطوير

- [ ] استخدام فئات CSS المناسبة
- [ ] تطبيق التصميم المتجاوب
- [ ] إضافة تأثيرات تدريجية
- [ ] معالجة الأخطاء بشكل صحيح

### ✅ قبل النشر

- [ ] اختبار شامل للوظائف
- [ ] تحسين الأداء
- [ ] فحص إمكانية الوصول
- [ ] توثيق التغييرات

---

<div align="center">

## 💫 الدعم والمساعدة

**هل تحتاج مساعدة؟**

📧 **البريد الإلكتروني**: [api-support@nmcore.dev](mailto:api-support@nmcore.dev)  
📚 **الوثائق**: [docs.nmcore.dev](https://docs.nmcore.dev)  
💬 **Discord**: [انضم لمجتمعنا](https://discord.gg/nmcore)  
🐛 **تقرير أخطاء**: [GitHub Issues](https://github.com/nmcore/issues)

---

**📅 آخر تحديث**: أغسطس 2025  
**📍 إصدار API**: v2.0  
**⚡ الحالة**: مستقر ومدعوم

</div>