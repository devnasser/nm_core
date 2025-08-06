/**
 * nm_core - نظام اعجوبة الأساسي
 * الملف الرئيسي للـ JavaScript
 * الإصدار: 2.0 الخارق
 * 
 * @author فريق نظام اعجوبة
 * @version 2.0.0
 */

// النظام الأساسي
const NMCore = {
    version: '2.0.0',
    debug: false,
    
    // الإعدادات الافتراضية
    config: {
        animations: {
            duration: 300,
            easing: 'ease-in-out',
            delay: 0
        },
        effects: {
            particles: true,
            parallax: true,
            smooth_scroll: true
        },
        performance: {
            gpu_acceleration: true,
            reduce_motion: false,
            lazy_loading: true
        }
    },

    // تهيئة النظام
    init() {
        this.log('🚀 تشغيل نظام اعجوبة الأساسي v' + this.version);
        
        // فحص الدعم للميزات المتقدمة
        this.checkSupport();
        
        // تهيئة المكونات
        this.initComponents();
        
        // تفعيل التأثيرات
        this.initEffects();
        
        // ربط الأحداث
        this.bindEvents();
        
        this.log('✅ تم تشغيل النظام بنجاح');
    },

    // فحص دعم المتصفح
    checkSupport() {
        const features = {
            css_variables: CSS.supports('color', 'var(--test)'),
            intersection_observer: 'IntersectionObserver' in window,
            request_animation_frame: 'requestAnimationFrame' in window,
            web_gl: !!window.WebGLRenderingContext,
            css_grid: CSS.supports('display', 'grid'),
            css_custom_properties: CSS.supports('--test', 'test')
        };

        this.log('🔍 فحص دعم المتصفح:', features);
        
        // حفظ معلومات الدعم
        this.support = features;
        
        // تحذيرات للمتصفحات القديمة
        if (!features.css_variables || !features.intersection_observer) {
            this.warn('⚠️ المتصفح قديم، قد تواجه مشاكل في الأداء');
        }
    },

    // تهيئة المكونات
    initComponents() {
        // تهيئة البطاقات التفاعلية
        this.initCards();
        
        // تهيئة الأزرار المتقدمة
        this.initButtons();
        
        // تهيئة النماذج
        this.initForms();
        
        // تهيئة التنقل
        this.initNavigation();
    },

    // تهيئة التأثيرات
    initEffects() {
        if (this.config.effects.particles) {
            this.initParticles();
        }
        
        if (this.config.effects.parallax) {
            this.initParallax();
        }
        
        if (this.config.effects.smooth_scroll) {
            this.initSmoothScroll();
        }

        // تأثيرات الظهور التدريجي
        this.initFadeInOnScroll();
    },

    // تهيئة البطاقات
    initCards() {
        const cards = document.querySelectorAll('.nm-card');
        
        cards.forEach(card => {
            // تأثير الهوفر المتقدم
            card.addEventListener('mouseenter', (e) => {
                if (this.config.performance.gpu_acceleration) {
                    e.target.style.transform = 'translateY(-10px) scale(1.02)';
                }
            });
            
            card.addEventListener('mouseleave', (e) => {
                e.target.style.transform = 'translateY(0) scale(1)';
            });

            // تأثير النقر
            card.addEventListener('click', (e) => {
                this.createRipple(e);
            });
        });
    },

    // تهيئة الأزرار
    initButtons() {
        const buttons = document.querySelectorAll('.nm-btn');
        
        buttons.forEach(button => {
            // تأثير الضغط
            button.addEventListener('mousedown', (e) => {
                e.target.style.transform = 'scale(0.95)';
            });
            
            button.addEventListener('mouseup', (e) => {
                e.target.style.transform = 'scale(1)';
            });

            // تأثير التموج
            button.addEventListener('click', (e) => {
                this.createRipple(e);
            });
        });
    },

    // تأثير التموج (Ripple)
    createRipple(event) {
        const button = event.currentTarget;
        const rect = button.getBoundingClientRect();
        const size = Math.max(rect.width, rect.height);
        const x = event.clientX - rect.left - size / 2;
        const y = event.clientY - rect.top - size / 2;
        
        const ripple = document.createElement('span');
        ripple.style.cssText = `
            position: absolute;
            width: ${size}px;
            height: ${size}px;
            left: ${x}px;
            top: ${y}px;
            background: rgba(255, 255, 255, 0.6);
            border-radius: 50%;
            transform: scale(0);
            animation: ripple 0.6s ease-out;
            pointer-events: none;
        `;
        
        // إضافة CSS للتأثير
        if (!document.querySelector('#ripple-styles')) {
            const style = document.createElement('style');
            style.id = 'ripple-styles';
            style.textContent = `
                @keyframes ripple {
                    to {
                        transform: scale(2);
                        opacity: 0;
                    }
                }
            `;
            document.head.appendChild(style);
        }
        
        button.style.position = 'relative';
        button.style.overflow = 'hidden';
        button.appendChild(ripple);
        
        setTimeout(() => {
            ripple.remove();
        }, 600);
    },

    // تهيئة الجسيمات
    initParticles() {
        const canvas = document.createElement('canvas');
        canvas.id = 'nm-particles';
        canvas.style.cssText = `
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            pointer-events: none;
            z-index: -1;
            opacity: 0.6;
        `;
        
        document.body.appendChild(canvas);
        
        const ctx = canvas.getContext('2d');
        const particles = [];
        const particleCount = 50;
        
        // تحديد حجم الكانفاس
        const resizeCanvas = () => {
            canvas.width = window.innerWidth;
            canvas.height = window.innerHeight;
        };
        
        resizeCanvas();
        window.addEventListener('resize', resizeCanvas);
        
        // إنشاء الجسيمات
        for (let i = 0; i < particleCount; i++) {
            particles.push({
                x: Math.random() * canvas.width,
                y: Math.random() * canvas.height,
                vx: (Math.random() - 0.5) * 2,
                vy: (Math.random() - 0.5) * 2,
                size: Math.random() * 3 + 1,
                opacity: Math.random() * 0.5 + 0.2
            });
        }
        
        // تحريك الجسيمات
        const animateParticles = () => {
            ctx.clearRect(0, 0, canvas.width, canvas.height);
            
            particles.forEach(particle => {
                // تحديث الموقع
                particle.x += particle.vx;
                particle.y += particle.vy;
                
                // إعادة تدوير الجسيمات
                if (particle.x < 0) particle.x = canvas.width;
                if (particle.x > canvas.width) particle.x = 0;
                if (particle.y < 0) particle.y = canvas.height;
                if (particle.y > canvas.height) particle.y = 0;
                
                // رسم الجسيمة
                ctx.beginPath();
                ctx.arc(particle.x, particle.y, particle.size, 0, Math.PI * 2);
                ctx.fillStyle = `rgba(255, 107, 107, ${particle.opacity})`;
                ctx.fill();
            });
            
            requestAnimationFrame(animateParticles);
        };
        
        animateParticles();
    },

    // تهيئة التمرير السلس
    initSmoothScroll() {
        // التمرير السلس للروابط الداخلية
        document.querySelectorAll('a[href^="#"]').forEach(anchor => {
            anchor.addEventListener('click', function (e) {
                e.preventDefault();
                const target = document.querySelector(this.getAttribute('href'));
                if (target) {
                    target.scrollIntoView({
                        behavior: 'smooth',
                        block: 'start'
                    });
                }
            });
        });
    },

    // تهيئة تأثير الظهور عند التمرير
    initFadeInOnScroll() {
        if (!this.support.intersection_observer) return;
        
        const observer = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    entry.target.classList.add('nm-animate-fadeIn');
                    observer.unobserve(entry.target);
                }
            });
        }, {
            threshold: 0.1,
            rootMargin: '0px 0px -50px 0px'
        });
        
        // مراقبة العناصر القابلة للحركة
        document.querySelectorAll('.nm-card, .nm-animate-on-scroll').forEach(el => {
            observer.observe(el);
        });
    },

    // تهيئة النماذج المحسنة
    initForms() {
        const forms = document.querySelectorAll('form');
        
        forms.forEach(form => {
            const inputs = form.querySelectorAll('input, textarea, select');
            
            inputs.forEach(input => {
                // تأثيرات التركيز
                input.addEventListener('focus', (e) => {
                    e.target.parentElement.classList.add('focused');
                });
                
                input.addEventListener('blur', (e) => {
                    e.target.parentElement.classList.remove('focused');
                    if (e.target.value) {
                        e.target.parentElement.classList.add('filled');
                    } else {
                        e.target.parentElement.classList.remove('filled');
                    }
                });
            });
        });
    },

    // ربط الأحداث العامة
    bindEvents() {
        // حفظ تفضيلات المستخدم
        this.bindPreferences();
        
        // مراقبة تغيير حجم النافذة
        window.addEventListener('resize', this.debounce(() => {
            this.onResize();
        }, 250));
        
        // مراقبة التمرير
        window.addEventListener('scroll', this.throttle(() => {
            this.onScroll();
        }, 16));
        
        // مراقبة حالة الشبكة
        if ('navigator' in window && 'onLine' in navigator) {
            window.addEventListener('online', () => {
                this.log('🌐 تم الاتصال بالإنترنت');
            });
            
            window.addEventListener('offline', () => {
                this.warn('📡 انقطع الاتصال بالإنترنت');
            });
        }
    },

    // حفظ تفضيلات المستخدم
    bindPreferences() {
        // فحص تفضيل تقليل الحركة
        if ('matchMedia' in window) {
            const prefersReducedMotion = window.matchMedia('(prefers-reduced-motion: reduce)');
            this.config.performance.reduce_motion = prefersReducedMotion.matches;
            
            prefersReducedMotion.addEventListener('change', (e) => {
                this.config.performance.reduce_motion = e.matches;
                this.log('⚙️ تم تحديث تفضيل الحركة:', e.matches ? 'مقللة' : 'عادية');
            });
        }
    },

    // معالج تغيير حجم النافذة
    onResize() {
        // إعادة حساب الأبعاد
        this.updateDimensions();
        
        // إعادة تهيئة التأثيرات إذا لزم الأمر
        if (this.config.effects.particles) {
            const canvas = document.querySelector('#nm-particles');
            if (canvas) {
                canvas.width = window.innerWidth;
                canvas.height = window.innerHeight;
            }
        }
    },

    // معالج التمرير
    onScroll() {
        // تأثيرات التمرير المخصصة
        const scrolled = window.pageYOffset;
        const rate = scrolled * -0.5;
        
        // تأثير المنظور للخلفية
        const parallaxElements = document.querySelectorAll('.nm-parallax');
        parallaxElements.forEach(element => {
            element.style.transform = `translateY(${rate}px)`;
        });
    },

    // تحديث الأبعاد
    updateDimensions() {
        const viewport = {
            width: window.innerWidth,
            height: window.innerHeight
        };
        
        // حفظ الأبعاد كمتغيرات CSS
        document.documentElement.style.setProperty('--viewport-width', viewport.width + 'px');
        document.documentElement.style.setProperty('--viewport-height', viewport.height + 'px');
    },

    // أدوات مساعدة للأداء
    debounce(func, wait) {
        let timeout;
        return function executedFunction(...args) {
            const later = () => {
                clearTimeout(timeout);
                func(...args);
            };
            clearTimeout(timeout);
            timeout = setTimeout(later, wait);
        };
    },

    throttle(func, limit) {
        let inThrottle;
        return function() {
            const args = arguments;
            const context = this;
            if (!inThrottle) {
                func.apply(context, args);
                inThrottle = true;
                setTimeout(() => inThrottle = false, limit);
            }
        };
    },

    // أدوات التطوير والتسجيل
    log(...args) {
        if (this.debug || window.location.search.includes('debug=true')) {
            console.log('%c[NM Core]', 'color: #ff6b6b; font-weight: bold;', ...args);
        }
    },

    warn(...args) {
        console.warn('%c[NM Core]', 'color: #ffd93d; font-weight: bold;', ...args);
    },

    error(...args) {
        console.error('%c[NM Core]', 'color: #e74c3c; font-weight: bold;', ...args);
    },

    // إدارة الذاكرة
    cleanup() {
        // إزالة مستمعي الأحداث
        window.removeEventListener('resize', this.onResize);
        window.removeEventListener('scroll', this.onScroll);
        
        // تنظيف الكانفاس
        const canvas = document.querySelector('#nm-particles');
        if (canvas) {
            canvas.remove();
        }
        
        this.log('🧹 تم تنظيف النظام');
    },

    // API للاستخدام الخارجي
    api: {
        // إنشاء إشعار
        notify(message, type = 'info', duration = 3000) {
            const notification = document.createElement('div');
            notification.className = `nm-notification nm-notification-${type}`;
            notification.textContent = message;
            notification.style.cssText = `
                position: fixed;
                top: 20px;
                right: 20px;
                padding: 15px 20px;
                background: var(--nm-primary);
                color: white;
                border-radius: 8px;
                box-shadow: var(--nm-shadow-medium);
                z-index: 10000;
                transform: translateX(400px);
                transition: transform 0.3s ease;
            `;
            
            document.body.appendChild(notification);
            
            // إظهار الإشعار
            setTimeout(() => {
                notification.style.transform = 'translateX(0)';
            }, 100);
            
            // إخفاء الإشعار
            setTimeout(() => {
                notification.style.transform = 'translateX(400px)';
                setTimeout(() => {
                    notification.remove();
                }, 300);
            }, duration);
        },

        // تحديث الإعدادات
        updateConfig(newConfig) {
            NMCore.config = { ...NMCore.config, ...newConfig };
            NMCore.log('⚙️ تم تحديث الإعدادات:', newConfig);
        },

        // الحصول على معلومات النظام
        getSystemInfo() {
            return {
                version: NMCore.version,
                support: NMCore.support,
                config: NMCore.config,
                viewport: {
                    width: window.innerWidth,
                    height: window.innerHeight
                },
                userAgent: navigator.userAgent,
                online: navigator.onLine
            };
        }
    }
};

// تهيئة النظام عند تحميل الصفحة
if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', () => NMCore.init());
} else {
    NMCore.init();
}

// تصدير النظام للاستخدام العالمي
window.NMCore = NMCore;

// معالج الأخطاء العالمي
window.addEventListener('error', (event) => {
    NMCore.error('خطأ في JavaScript:', event.error);
});

// إدارة دورة حياة الصفحة
window.addEventListener('beforeunload', () => {
    NMCore.cleanup();
});

// تصدير API المبسط
window.nm = NMCore.api;

// رسالة الترحيب في الكونسول
console.log(`
%c
🌟 مرحباً بك في نظام اعجوبة الأساسي
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📦 الإصدار: ${NMCore.version}
🚀 تم التحميل بنجاح
💡 استخدم nm.getSystemInfo() لمعرفة تفاصيل النظام
🔧 استخدم nm.notify('رسالة') لإظهار إشعار
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
`, 'color: #ff6b6b; font-family: monospace; font-size: 12px;');

// نهاية الملف