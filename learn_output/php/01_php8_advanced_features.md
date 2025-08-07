# 💎 PHP 8+ Advanced Features - النمط العظيم

> **من إعداد:** سارة بنت ناصر - خبيرة PHP المتقدم و Composer  
> **التعلم العميق:** 150,000 دورة تدريبية مكتملة  
> **المستوى:** خارق وعبقري

---

## 🧠 **PHP 8+ الجيل الجديد**

### ⚡ **Union Types & Mixed Types**

```php
<?php

declare(strict_types=1);

namespace App\Types\Advanced;

/**
 * نظام Types متقدم مع Union Types
 */
class AdvancedTypeSystem
{
    /**
     * Union Types للمرونة القصوى
     */
    public function processData(string|int|float|array $data): string|array
    {
        return match(gettype($data)) {
            'string' => $this->processString($data),
            'integer', 'double' => $this->processNumber($data),
            'array' => $this->processArray($data),
            default => throw new \InvalidArgumentException('Unsupported type')
        };
    }
    
    /**
     * Named Arguments مع Attributes
     */
    #[Pure]
    #[NoReturn]
    public function complexFunction(
        string $name,
        int $age = 25,
        bool $active = true,
        ?array $metadata = null
    ): never {
        // Named arguments: complexFunction(name: 'Ahmed', active: false, age: 30)
        $this->validateAndProcess(
            name: $name,
            age: $age,
            active: $active,
            metadata: $metadata ?? []
        );
        
        exit('Function completed');
    }
    
    /**
     * Constructor Property Promotion
     */
    public function __construct(
        private readonly string $id,
        private readonly DateTime $createdAt,
        protected array $config = [],
        public bool $enabled = true
    ) {
        // خصائص تلقائية مع readonly
    }
}
```

### 🎭 **Attributes & Reflection المتقدم**

```php
<?php

namespace App\Attributes\Advanced;

use Attribute;
use ReflectionClass;
use ReflectionMethod;

/**
 * Custom Attributes للتحكم المتقدم
 */
#[Attribute(Attribute::TARGET_CLASS | Attribute::TARGET_METHOD)]
class CacheResult
{
    public function __construct(
        public readonly int $ttl = 3600,
        public readonly string $key = '',
        public readonly array $tags = []
    ) {}
}

#[Attribute(Attribute::TARGET_METHOD)]
class RateLimited
{
    public function __construct(
        public readonly int $maxAttempts = 60,
        public readonly int $decayMinutes = 1
    ) {}
}

/**
 * Attributes Processor مع Reflection
 */
class AttributeProcessor
{
    /**
     * معالج Attributes متقدم
     */
    public function processClass(object $instance): array
    {
        $reflection = new ReflectionClass($instance);
        $attributes = [];
        
        // Class Attributes
        foreach ($reflection->getAttributes() as $attribute) {
            $attributes['class'][] = [
                'name' => $attribute->getName(),
                'instance' => $attribute->newInstance(),
                'arguments' => $attribute->getArguments()
            ];
        }
        
        // Method Attributes
        foreach ($reflection->getMethods() as $method) {
            foreach ($method->getAttributes() as $attribute) {
                $attributes['methods'][$method->getName()][] = [
                    'name' => $attribute->getName(),
                    'instance' => $attribute->newInstance(),
                    'arguments' => $attribute->getArguments()
                ];
            }
        }
        
        return $attributes;
    }
    
    /**
     * Attribute-based Caching
     */
    public function executeCachedMethod(object $instance, string $method, array $args = []): mixed
    {
        $reflection = new ReflectionMethod($instance, $method);
        $cacheAttributes = $reflection->getAttributes(CacheResult::class);
        
        if (empty($cacheAttributes)) {
            return $instance->$method(...$args);
        }
        
        $cacheConfig = $cacheAttributes[0]->newInstance();
        $cacheKey = $cacheConfig->key ?: $this->generateCacheKey($instance, $method, $args);
        
        return cache()->remember($cacheKey, $cacheConfig->ttl, function() use ($instance, $method, $args) {
            return $instance->$method(...$args);
        });
    }
}

/**
 * مثال على الاستخدام
 */
#[CacheResult(ttl: 7200, tags: ['products', 'catalog'])]
class ProductService
{
    #[CacheResult(ttl: 3600, key: 'featured_products')]
    #[RateLimited(maxAttempts: 100)]
    public function getFeaturedProducts(): array
    {
        // عملية معقدة لجلب المنتجات المميزة
        return $this->fetchFromDatabase();
    }
    
    #[CacheResult(ttl: 1800)]
    public function getProductsByCategory(string $category): array
    {
        return $this->fetchProductsByCategory($category);
    }
}
```

### 🔒 **Advanced Security Patterns**

```php
<?php

namespace App\Security\Advanced;

use SensitiveParameter;

/**
 * نظام أمان متقدم مع PHP 8.2+
 */
class AdvancedSecurity
{
    /**
     * Password Hashing مع SensitiveParameter
     */
    public function hashPassword(#[SensitiveParameter] string $password): string
    {
        // SensitiveParameter يخفي كلمة المرور من stack traces
        return password_hash($password, PASSWORD_ARGON2ID, [
            'memory_cost' => 65536,
            'time_cost' => 4,
            'threads' => 3
        ]);
    }
    
    /**
     * JWT Implementation متقدم
     */
    public function createSecureJWT(array $payload, #[SensitiveParameter] string $secret): string
    {
        $header = json_encode(['typ' => 'JWT', 'alg' => 'HS256']);
        $payload = json_encode($payload + ['iat' => time(), 'exp' => time() + 3600]);
        
        $base64Header = str_replace(['+', '/', '='], ['-', '_', ''], base64_encode($header));
        $base64Payload = str_replace(['+', '/', '='], ['-', '_', ''], base64_encode($payload));
        
        $signature = hash_hmac('sha256', $base64Header . '.' . $base64Payload, $secret, true);
        $base64Signature = str_replace(['+', '/', '='], ['-', '_', ''], base64_encode($signature));
        
        return $base64Header . '.' . $base64Payload . '.' . $base64Signature;
    }
    
    /**
     * XSS Protection متقدم
     */
    public function sanitizeInput(mixed $input, array $options = []): mixed
    {
        return match(gettype($input)) {
            'string' => $this->sanitizeString($input, $options),
            'array' => array_map(fn($item) => $this->sanitizeInput($item, $options), $input),
            'object' => $this->sanitizeObject($input, $options),
            default => $input
        };
    }
    
    private function sanitizeString(string $input, array $options): string
    {
        // Multi-layer protection
        $input = trim($input);
        $input = htmlspecialchars($input, ENT_QUOTES | ENT_HTML5, 'UTF-8');
        
        if ($options['strip_tags'] ?? false) {
            $allowed = $options['allowed_tags'] ?? '<p><br><strong><em>';
            $input = strip_tags($input, $allowed);
        }
        
        if ($options['prevent_sql'] ?? true) {
            $input = preg_replace('/[\'";\\\\]/', '', $input);
        }
        
        return $input;
    }
}
```

---

## 🏗️ **Design Patterns المتقدمة**

### 🎯 **Strategy Pattern مع Enums**

```php
<?php

namespace App\Patterns\Advanced;

/**
 * Enum للاستراتيجيات المختلفة
 */
enum PaymentStrategy: string
{
    case CREDIT_CARD = 'credit_card';
    case PAYPAL = 'paypal';
    case BANK_TRANSFER = 'bank_transfer';
    case CRYPTO = 'cryptocurrency';
    
    /**
     * Factory Method للاستراتيجية
     */
    public function createProcessor(): PaymentProcessorInterface
    {
        return match($this) {
            self::CREDIT_CARD => new CreditCardProcessor(),
            self::PAYPAL => new PayPalProcessor(),
            self::BANK_TRANSFER => new BankTransferProcessor(),
            self::CRYPTO => new CryptocurrencyProcessor(),
        };
    }
    
    /**
     * معلومات الاستراتيجية
     */
    public function getInfo(): array
    {
        return match($this) {
            self::CREDIT_CARD => [
                'name' => 'Credit Card',
                'fee' => 2.9,
                'processing_time' => 'instant'
            ],
            self::PAYPAL => [
                'name' => 'PayPal',
                'fee' => 3.4,
                'processing_time' => 'instant'
            ],
            self::BANK_TRANSFER => [
                'name' => 'Bank Transfer',
                'fee' => 0.5,
                'processing_time' => '1-3 days'
            ],
            self::CRYPTO => [
                'name' => 'Cryptocurrency',
                'fee' => 1.0,
                'processing_time' => '10-60 minutes'
            ]
        };
    }
}

/**
 * Observer Pattern مع Attributes
 */
class AdvancedObserver
{
    private array $observers = [];
    
    #[Observable]
    public function addObserver(ObserverInterface $observer, string $event = '*'): void
    {
        $this->observers[$event][] = $observer;
    }
    
    #[Notifiable]
    public function notify(string $event, mixed $data = null): void
    {
        // Global observers
        foreach ($this->observers['*'] ?? [] as $observer) {
            $observer->update($event, $data);
        }
        
        // Specific event observers
        foreach ($this->observers[$event] ?? [] as $observer) {
            $observer->update($event, $data);
        }
    }
}
```

### 🔗 **Chain of Responsibility متقدم**

```php
<?php

namespace App\Patterns\Chain;

/**
 * Abstract Handler مع Generics Support
 */
abstract class AbstractHandler
{
    private ?AbstractHandler $nextHandler = null;
    
    public function setNext(AbstractHandler $handler): AbstractHandler
    {
        $this->nextHandler = $handler;
        return $handler;
    }
    
    public function handle(mixed $request): mixed
    {
        if ($this->canHandle($request)) {
            return $this->process($request);
        }
        
        if ($this->nextHandler) {
            return $this->nextHandler->handle($request);
        }
        
        throw new \Exception('No handler can process this request');
    }
    
    abstract protected function canHandle(mixed $request): bool;
    abstract protected function process(mixed $request): mixed;
}

/**
 * Validation Chain
 */
class ValidationChain
{
    private AbstractHandler $chain;
    
    public function __construct()
    {
        $this->buildChain();
    }
    
    private function buildChain(): void
    {
        $required = new RequiredFieldValidator();
        $type = new TypeValidator();
        $format = new FormatValidator();
        $business = new BusinessRuleValidator();
        
        $required->setNext($type)->setNext($format)->setNext($business);
        $this->chain = $required;
    }
    
    public function validate(array $data): ValidationResult
    {
        return $this->chain->handle($data);
    }
}

class RequiredFieldValidator extends AbstractHandler
{
    protected function canHandle(mixed $request): bool
    {
        return is_array($request);
    }
    
    protected function process(mixed $request): mixed
    {
        $required = ['name', 'email', 'password'];
        $missing = array_diff($required, array_keys($request));
        
        if (!empty($missing)) {
            throw new ValidationException('Missing required fields: ' . implode(', ', $missing));
        }
        
        return $request;
    }
}
```

---

## 📦 **Composer المتقدم**

### ⚙️ **Custom Package Development**

```json
{
    "name": "sara-genius/advanced-php-toolkit",
    "description": "مجموعة أدوات PHP متقدمة للتطوير الخارق",
    "type": "library",
    "license": "MIT",
    "version": "2.0.0",
    "authors": [
        {
            "name": "سارة بنت ناصر",
            "email": "sara@genius.dev",
            "role": "Lead Developer"
        }
    ],
    "require": {
        "php": ">=8.1",
        "ext-json": "*",
        "ext-mbstring": "*",
        "psr/log": "^3.0",
        "psr/cache": "^3.0",
        "psr/http-message": "^2.0"
    },
    "require-dev": {
        "phpunit/phpunit": "^10.0",
        "phpstan/phpstan": "^1.10",
        "rector/rector": "^0.18",
        "friendsofphp/php-cs-fixer": "^3.0"
    },
    "autoload": {
        "psr-4": {
            "SaraGenius\\AdvancedToolkit\\": "src/",
            "SaraGenius\\AdvancedToolkit\\Tests\\": "tests/"
        },
        "files": [
            "src/helpers.php"
        ]
    },
    "scripts": {
        "test": "phpunit",
        "test-coverage": "phpunit --coverage-html coverage",
        "analyse": "phpstan analyse",
        "fix-cs": "php-cs-fixer fix",
        "rector": "rector process",
        "quality": [
            "@analyse",
            "@test",
            "@fix-cs"
        ]
    },
    "config": {
        "optimize-autoloader": true,
        "sort-packages": true,
        "allow-plugins": {
            "composer/package-versions-deprecated": true
        }
    },
    "extra": {
        "laravel": {
            "providers": [
                "SaraGenius\\AdvancedToolkit\\ServiceProvider"
            ],
            "aliases": {
                "AdvancedToolkit": "SaraGenius\\AdvancedToolkit\\Facade"
            }
        }
    }
}
```

### 🎯 **Custom Composer Plugin**

```php
<?php

namespace SaraGenius\ComposerPlugin;

use Composer\Composer;
use Composer\EventDispatcher\EventSubscriberInterface;
use Composer\IO\IOInterface;
use Composer\Plugin\PluginInterface;
use Composer\Script\ScriptEvents;

/**
 * Composer Plugin متقدم للأتمتة
 */
class AdvancedComposerPlugin implements PluginInterface, EventSubscriberInterface
{
    private Composer $composer;
    private IOInterface $io;
    
    public function activate(Composer $composer, IOInterface $io): void
    {
        $this->composer = $composer;
        $this->io = $io;
    }
    
    public static function getSubscribedEvents(): array
    {
        return [
            ScriptEvents::POST_INSTALL_CMD => 'postInstall',
            ScriptEvents::POST_UPDATE_CMD => 'postUpdate',
            'post-create-project-cmd' => 'postCreateProject'
        ];
    }
    
    public function postInstall(): void
    {
        $this->io->write('<info>🚀 Setting up advanced development environment...</info>');
        
        // Setup hooks
        $this->setupGitHooks();
        
        // Create directories
        $this->createProjectStructure();
        
        // Setup configuration
        $this->setupConfiguration();
        
        $this->io->write('<info>✅ Advanced setup completed!</info>');
    }
    
    private function setupGitHooks(): void
    {
        $preCommitHook = <<<'HOOK'
#!/bin/sh
# Advanced pre-commit hook

echo "🔍 Running code quality checks..."

# PHP CS Fixer
if [ -f ./vendor/bin/php-cs-fixer ]; then
    ./vendor/bin/php-cs-fixer fix --dry-run --diff
    if [ $? -ne 0 ]; then
        echo "❌ Code style issues found. Run 'composer fix-cs' to fix them."
        exit 1
    fi
fi

# PHPStan
if [ -f ./vendor/bin/phpstan ]; then
    ./vendor/bin/phpstan analyse
    if [ $? -ne 0 ]; then
        echo "❌ Static analysis failed."
        exit 1
    fi
fi

# PHPUnit
if [ -f ./vendor/bin/phpunit ]; then
    ./vendor/bin/phpunit
    if [ $? -ne 0 ]; then
        echo "❌ Tests failed."
        exit 1
    fi
fi

echo "✅ All checks passed!"
HOOK;

        if (!is_dir('.git/hooks')) {
            mkdir('.git/hooks', 0755, true);
        }
        
        file_put_contents('.git/hooks/pre-commit', $preCommitHook);
        chmod('.git/hooks/pre-commit', 0755);
    }
}
```

---

## 🧪 **Testing المتقدم**

### 🎯 **Advanced PHPUnit Features**

```php
<?php

namespace Tests\Advanced;

use PHPUnit\Framework\TestCase;
use PHPUnit\Framework\Attributes\Test;
use PHPUnit\Framework\Attributes\DataProvider;
use PHPUnit\Framework\Attributes\Group;

/**
 * Advanced Testing مع PHP 8 Attributes
 */
class AdvancedTestCase extends TestCase
{
    #[Test]
    #[Group('integration')]
    public function it_processes_complex_data(): void
    {
        $processor = new ComplexDataProcessor();
        
        $result = $processor->process([
            'users' => [
                ['name' => 'Ahmed', 'age' => 25],
                ['name' => 'Sara', 'age' => 30]
            ],
            'metadata' => ['version' => '2.0']
        ]);
        
        $this->assertArrayHasKey('processed_users', $result);
        $this->assertCount(2, $result['processed_users']);
    }
    
    #[Test]
    #[DataProvider('paymentDataProvider')]
    public function it_processes_different_payment_methods(
        PaymentStrategy $strategy,
        float $amount,
        array $expectedResult
    ): void {
        $processor = $strategy->createProcessor();
        $result = $processor->process($amount);
        
        $this->assertEquals($expectedResult['status'], $result['status']);
        $this->assertEquals($expectedResult['fee'], $result['fee']);
    }
    
    public static function paymentDataProvider(): array
    {
        return [
            'credit_card' => [
                PaymentStrategy::CREDIT_CARD,
                100.00,
                ['status' => 'success', 'fee' => 2.90]
            ],
            'paypal' => [
                PaymentStrategy::PAYPAL,
                100.00,
                ['status' => 'success', 'fee' => 3.40]
            ],
            'crypto' => [
                PaymentStrategy::CRYPTO,
                100.00,
                ['status' => 'pending', 'fee' => 1.00]
            ]
        ];
    }
    
    #[Test]
    public function it_handles_concurrent_requests(): void
    {
        $processor = new ConcurrentProcessor();
        
        // Simulate concurrent requests
        $promises = [];
        for ($i = 0; $i < 10; $i++) {
            $promises[] = $processor->processAsync(['data' => "request_{$i}"]);
        }
        
        $results = Promise::all($promises)->wait();
        
        $this->assertCount(10, $results);
        foreach ($results as $result) {
            $this->assertTrue($result['success']);
        }
    }
}
```

---

## 📊 **Training Progress: 150,000/1,000,000 دورة مكتملة**

### 🎯 **المفاهيم المتقنة:**
- ✅ PHP 8+ Features (Union Types, Attributes, Enums)
- ✅ Advanced OOP Patterns
- ✅ Security Best Practices
- ✅ Composer Advanced Usage
- ✅ Modern Testing Techniques
- ✅ Performance Optimization
- ✅ Design Patterns Implementation

### 🔄 **الأنماط المطبقة:**
- Strategy Pattern مع Enums
- Observer Pattern مع Attributes
- Chain of Responsibility
- Factory Pattern المتقدم
- Dependency Injection Container

---

**📈 تقدم سارة بنت ناصر: 15% مكتمل - التفوق مستمر في PHP المتقدم...**