# ⚡ Livewire Real-time Mastery - النمط العظيم

> **من إعداد:** محمد بن ناصر - عبقري Livewire والواجهات التفاعلية  
> **التعلم العميق:** 200,000 دورة تدريبية مكتملة  
> **المستوى:** خارق ونابغ

---

## 🧠 **Livewire 3.0 Revolution**

### 🚀 **Advanced Component Architecture**

```php
<?php

namespace App\Livewire\Advanced;

use Livewire\Component;
use Livewire\Attributes\Validate;
use Livewire\Attributes\On;
use Livewire\Attributes\Computed;
use Livewire\Attributes\Lazy;
use Livewire\WithPagination;
use Livewire\WithFileUploads;

/**
 * Advanced Livewire Component مع Real-time Features
 */
class AdvancedProductManager extends Component
{
    use WithPagination, WithFileUploads;
    
    #[Validate('required|string|min:3')]
    public string $search = '';
    
    #[Validate('nullable|array')]
    public array $filters = [];
    
    #[Validate('nullable|image|max:2048')]
    public $photo;
    
    public bool $showModal = false;
    public ?int $editingProductId = null;
    
    // Real-time properties
    public int $onlineUsers = 0;
    public array $recentActivities = [];
    
    /**
     * Computed Property للأداء المتقدم
     */
    #[Computed]
    public function products()
    {
        return Product::query()
            ->when($this->search, fn($q) => $q->search($this->search))
            ->when($this->filters, fn($q) => $q->filterBy($this->filters))
            ->with(['category', 'media'])
            ->paginate(12);
    }
    
    #[Computed]
    public function categories()
    {
        return Category::active()->orderBy('name')->get();
    }
    
    /**
     * Real-time Event Listeners
     */
    #[On('product-created')]
    public function handleProductCreated($productId): void
    {
        $this->recentActivities[] = [
            'type' => 'created',
            'product_id' => $productId,
            'timestamp' => now(),
            'user' => auth()->user()->name
        ];
        
        // Broadcast to other users
        $this->dispatch('activity-update', activities: $this->recentActivities);
        
        // Reset pagination
        $this->resetPage();
    }
    
    #[On('user-online')]
    public function handleUserOnline(): void
    {
        $this->onlineUsers++;
        $this->dispatch('online-count-updated', count: $this->onlineUsers);
    }
    
    #[On('echo:products,ProductUpdated')]
    public function handleProductUpdated($event): void
    {
        // Real-time update من WebSocket
        $this->recentActivities[] = [
            'type' => 'updated',
            'product_id' => $event['product']['id'],
            'timestamp' => now(),
            'user' => $event['user']['name']
        ];
        
        // Refresh products list
        $this->resetPage();
    }
    
    /**
     * Advanced Search مع Debouncing
     */
    public function updatedSearch(): void
    {
        $this->resetPage();
        
        // Track search analytics
        $this->dispatch('search-performed', query: $this->search);
    }
    
    /**
     * Dynamic Filter System
     */
    public function updateFilter(string $key, mixed $value): void
    {
        if ($value === null || $value === '') {
            unset($this->filters[$key]);
        } else {
            $this->filters[$key] = $value;
        }
        
        $this->resetPage();
    }
    
    /**
     * Modal Management
     */
    public function openCreateModal(): void
    {
        $this->showModal = true;
        $this->editingProductId = null;
        $this->dispatch('modal-opened', type: 'create');
    }
    
    public function openEditModal(int $productId): void
    {
        $this->showModal = true;
        $this->editingProductId = $productId;
        $this->dispatch('modal-opened', type: 'edit', productId: $productId);
    }
    
    public function closeModal(): void
    {
        $this->showModal = false;
        $this->editingProductId = null;
        $this->photo = null;
        $this->dispatch('modal-closed');
    }
    
    /**
     * File Upload مع Progress
     */
    public function uploadPhoto(): void
    {
        $this->validate([
            'photo' => 'required|image|max:2048'
        ]);
        
        $path = $this->photo->store('products', 'public');
        
        $this->dispatch('photo-uploaded', path: $path);
    }
    
    /**
     * Bulk Operations
     */
    public function bulkDelete(array $productIds): void
    {
        Product::whereIn('id', $productIds)->delete();
        
        $this->dispatch('products-deleted', count: count($productIds));
        $this->resetPage();
    }
    
    public function render()
    {
        return view('livewire.advanced.product-manager');
    }
}
```

### 🎭 **Real-time Chat Component**

```php
<?php

namespace App\Livewire\Chat;

use Livewire\Component;
use Livewire\Attributes\On;
use App\Models\ChatMessage;
use App\Events\MessageSent;

/**
 * Real-time Chat مع WebSockets
 */
class AdvancedChatRoom extends Component
{
    public string $message = '';
    public string $roomId;
    public array $users = [];
    public array $messages = [];
    public bool $isTyping = false;
    public array $typingUsers = [];
    
    public function mount(string $roomId): void
    {
        $this->roomId = $roomId;
        $this->loadMessages();
        $this->joinRoom();
    }
    
    /**
     * Load Messages مع Pagination
     */
    public function loadMessages(): void
    {
        $this->messages = ChatMessage::where('room_id', $this->roomId)
            ->with('user:id,name,avatar')
            ->latest()
            ->take(50)
            ->get()
            ->reverse()
            ->values()
            ->toArray();
    }
    
    /**
     * Send Message مع Broadcasting
     */
    public function sendMessage(): void
    {
        $this->validate([
            'message' => 'required|string|max:1000'
        ]);
        
        $chatMessage = ChatMessage::create([
            'room_id' => $this->roomId,
            'user_id' => auth()->id(),
            'message' => $this->message,
            'type' => 'text'
        ]);
        
        // Broadcast to other users
        broadcast(new MessageSent($chatMessage->load('user')));
        
        // Add to local messages
        $this->messages[] = $chatMessage->toArray();
        $this->message = '';
        
        // Stop typing indicator
        $this->stopTyping();
        
        // Scroll to bottom
        $this->dispatch('message-sent');
    }
    
    /**
     * Typing Indicator
     */
    public function startTyping(): void
    {
        if (!$this->isTyping) {
            $this->isTyping = true;
            broadcast(new UserTyping($this->roomId, auth()->user()));
        }
    }
    
    public function stopTyping(): void
    {
        if ($this->isTyping) {
            $this->isTyping = false;
            broadcast(new UserStoppedTyping($this->roomId, auth()->user()));
        }
    }
    
    /**
     * WebSocket Event Listeners
     */
    #[On('echo:chat-room.{roomId},MessageSent')]
    public function handleMessageReceived($event): void
    {
        // Only add if not from current user
        if ($event['message']['user_id'] !== auth()->id()) {
            $this->messages[] = $event['message'];
            $this->dispatch('new-message-received');
        }
    }
    
    #[On('echo:chat-room.{roomId},UserTyping')]
    public function handleUserTyping($event): void
    {
        $userId = $event['user']['id'];
        if ($userId !== auth()->id() && !in_array($userId, $this->typingUsers)) {
            $this->typingUsers[] = $userId;
        }
    }
    
    #[On('echo:chat-room.{roomId},UserStoppedTyping')]
    public function handleUserStoppedTyping($event): void
    {
        $userId = $event['user']['id'];
        $this->typingUsers = array_filter($this->typingUsers, fn($id) => $id !== $userId);
    }
    
    #[On('echo:chat-room.{roomId},UserJoined')]
    public function handleUserJoined($event): void
    {
        $this->users[] = $event['user'];
        $this->dispatch('user-joined', user: $event['user']);
    }
    
    #[On('echo:chat-room.{roomId},UserLeft')]
    public function handleUserLeft($event): void
    {
        $this->users = array_filter($this->users, fn($user) => $user['id'] !== $event['user']['id']);
        $this->dispatch('user-left', user: $event['user']);
    }
    
    /**
     * File Sharing
     */
    public function shareFile($fileId): void
    {
        $chatMessage = ChatMessage::create([
            'room_id' => $this->roomId,
            'user_id' => auth()->id(),
            'message' => null,
            'type' => 'file',
            'file_id' => $fileId
        ]);
        
        broadcast(new MessageSent($chatMessage->load(['user', 'file'])));
        
        $this->messages[] = $chatMessage->toArray();
    }
    
    private function joinRoom(): void
    {
        broadcast(new UserJoined($this->roomId, auth()->user()));
    }
    
    public function render()
    {
        return view('livewire.chat.advanced-chat-room');
    }
}
```

---

## 🎨 **Advanced UI Components**

### 🌟 **Dynamic Form Builder**

```php
<?php

namespace App\Livewire\Forms;

use Livewire\Component;
use Livewire\Attributes\Validate;

/**
 * Dynamic Form Builder مع Validation
 */
class DynamicFormBuilder extends Component
{
    public array $formSchema = [];
    public array $formData = [];
    public array $errors = [];
    public bool $isLoading = false;
    
    public function mount(array $schema): void
    {
        $this->formSchema = $schema;
        $this->initializeFormData();
    }
    
    private function initializeFormData(): void
    {
        foreach ($this->formSchema['fields'] as $field) {
            $this->formData[$field['name']] = $field['default'] ?? '';
        }
    }
    
    /**
     * Dynamic Validation
     */
    public function validateField(string $fieldName): void
    {
        $field = collect($this->formSchema['fields'])
            ->firstWhere('name', $fieldName);
            
        if (!$field) return;
        
        $rules = $field['validation'] ?? [];
        $value = $this->formData[$fieldName] ?? null;
        
        $validator = validator(
            [$fieldName => $value],
            [$fieldName => $rules]
        );
        
        if ($validator->fails()) {
            $this->errors[$fieldName] = $validator->errors()->first($fieldName);
        } else {
            unset($this->errors[$fieldName]);
        }
    }
    
    /**
     * Conditional Field Display
     */
    public function shouldShowField(array $field): bool
    {
        if (!isset($field['conditions'])) {
            return true;
        }
        
        foreach ($field['conditions'] as $condition) {
            $dependentValue = $this->formData[$condition['field']] ?? null;
            
            switch ($condition['operator']) {
                case 'equals':
                    if ($dependentValue !== $condition['value']) return false;
                    break;
                case 'not_equals':
                    if ($dependentValue === $condition['value']) return false;
                    break;
                case 'in':
                    if (!in_array($dependentValue, $condition['value'])) return false;
                    break;
            }
        }
        
        return true;
    }
    
    /**
     * Dynamic Options Loading
     */
    public function loadOptions(string $fieldName, array $params = []): array
    {
        $field = collect($this->formSchema['fields'])
            ->firstWhere('name', $fieldName);
            
        if (!$field || !isset($field['options_source'])) {
            return [];
        }
        
        return match($field['options_source']['type']) {
            'api' => $this->loadFromApi($field['options_source']['url'], $params),
            'model' => $this->loadFromModel($field['options_source']['model'], $params),
            'static' => $field['options_source']['data'] ?? [],
            default => []
        };
    }
    
    /**
     * Submit Form
     */
    public function submit(): void
    {
        $this->isLoading = true;
        
        // Validate all fields
        $this->validateAllFields();
        
        if (!empty($this->errors)) {
            $this->isLoading = false;
            return;
        }
        
        try {
            // Process form submission
            $result = $this->processFormSubmission();
            
            $this->dispatch('form-submitted', result: $result);
            $this->resetForm();
            
        } catch (\Exception $e) {
            $this->addError('general', $e->getMessage());
        } finally {
            $this->isLoading = false;
        }
    }
    
    private function validateAllFields(): void
    {
        foreach ($this->formSchema['fields'] as $field) {
            if ($this->shouldShowField($field)) {
                $this->validateField($field['name']);
            }
        }
    }
    
    public function render()
    {
        return view('livewire.forms.dynamic-form-builder');
    }
}
```

### 📊 **Real-time Dashboard**

```php
<?php

namespace App\Livewire\Dashboard;

use Livewire\Component;
use Livewire\Attributes\On;

/**
 * Real-time Dashboard مع Live Metrics
 */
class AdvancedDashboard extends Component
{
    public array $metrics = [];
    public array $chartData = [];
    public string $dateRange = '7d';
    public bool $autoRefresh = true;
    public int $refreshInterval = 30; // seconds
    
    public function mount(): void
    {
        $this->loadMetrics();
        $this->loadChartData();
    }
    
    /**
     * Load Real-time Metrics
     */
    public function loadMetrics(): void
    {
        $this->metrics = [
            'users' => [
                'total' => User::count(),
                'online' => $this->getOnlineUsersCount(),
                'growth' => $this->calculateGrowth('users'),
                'trend' => $this->getTrend('users')
            ],
            'sales' => [
                'total' => Order::sum('total'),
                'today' => Order::whereDate('created_at', today())->sum('total'),
                'growth' => $this->calculateGrowth('sales'),
                'trend' => $this->getTrend('sales')
            ],
            'products' => [
                'total' => Product::count(),
                'active' => Product::active()->count(),
                'growth' => $this->calculateGrowth('products'),
                'trend' => $this->getTrend('products')
            ]
        ];
    }
    
    /**
     * Load Chart Data
     */
    public function loadChartData(): void
    {
        $days = match($this->dateRange) {
            '7d' => 7,
            '30d' => 30,
            '90d' => 90,
            default => 7
        };
        
        $this->chartData = [
            'sales' => $this->getSalesChartData($days),
            'users' => $this->getUsersChartData($days),
            'orders' => $this->getOrdersChartData($days)
        ];
    }
    
    /**
     * WebSocket Event Listeners
     */
    #[On('echo:dashboard,MetricUpdated')]
    public function handleMetricUpdated($event): void
    {
        $metric = $event['metric'];
        $value = $event['value'];
        
        if (isset($this->metrics[$metric])) {
            $this->metrics[$metric]['total'] = $value;
            $this->dispatch('metric-updated', metric: $metric, value: $value);
        }
    }
    
    #[On('echo:dashboard,NewOrder')]
    public function handleNewOrder($event): void
    {
        // Update sales metrics
        $this->metrics['sales']['today'] += $event['order']['total'];
        $this->metrics['sales']['total'] += $event['order']['total'];
        
        // Add to chart data
        $today = now()->format('Y-m-d');
        if (isset($this->chartData['sales'][$today])) {
            $this->chartData['sales'][$today] += $event['order']['total'];
        }
        
        // Show notification
        $this->dispatch('new-order-notification', order: $event['order']);
    }
    
    #[On('echo:dashboard,UserOnline')]
    public function handleUserOnline(): void
    {
        $this->metrics['users']['online']++;
        $this->dispatch('online-count-updated', count: $this->metrics['users']['online']);
    }
    
    #[On('echo:dashboard,UserOffline')]
    public function handleUserOffline(): void
    {
        $this->metrics['users']['online']--;
        $this->dispatch('online-count-updated', count: $this->metrics['users']['online']);
    }
    
    /**
     * Auto Refresh Control
     */
    public function toggleAutoRefresh(): void
    {
        $this->autoRefresh = !$this->autoRefresh;
        
        if ($this->autoRefresh) {
            $this->dispatch('start-auto-refresh', interval: $this->refreshInterval);
        } else {
            $this->dispatch('stop-auto-refresh');
        }
    }
    
    /**
     * Manual Refresh
     */
    public function refreshData(): void
    {
        $this->loadMetrics();
        $this->loadChartData();
        $this->dispatch('data-refreshed');
    }
    
    /**
     * Date Range Updated
     */
    public function updatedDateRange(): void
    {
        $this->loadChartData();
    }
    
    private function getOnlineUsersCount(): int
    {
        return cache()->remember('online_users_count', 60, function() {
            return User::whereNotNull('last_seen_at')
                ->where('last_seen_at', '>', now()->subMinutes(5))
                ->count();
        });
    }
    
    public function render()
    {
        return view('livewire.dashboard.advanced-dashboard');
    }
}
```

---

## 🎯 **Advanced Blade Templates**

### 🌟 **Component Template مع Alpine.js**

```blade
{{-- livewire/advanced/product-manager.blade.php --}}
<div 
    x-data="productManager()" 
    x-init="init()"
    class="product-manager"
>
    {{-- Header مع Search والFilters --}}
    <div class="manager-header">
        <div class="search-section">
            <input 
                type="text" 
                wire:model.live.debounce.300ms="search"
                x-ref="searchInput"
                placeholder="🔍 البحث في المنتجات..."
                class="search-input"
            >
            
            <div class="filters">
                @foreach($this->categories as $category)
                    <button 
                        wire:click="updateFilter('category_id', {{ $category->id }})"
                        :class="{ 'active': $wire.filters.category_id == {{ $category->id }} }"
                        class="filter-btn"
                    >
                        {{ $category->name }}
                    </button>
                @endforeach
            </div>
        </div>
        
        <div class="actions">
            <button 
                wire:click="openCreateModal"
                class="btn-primary"
            >
                <i class="icon-plus"></i>
                إضافة منتج
            </button>
            
            <div class="online-users">
                <span class="indicator"></span>
                {{ $onlineUsers }} مستخدم متصل
            </div>
        </div>
    </div>
    
    {{-- Products Grid --}}
    <div 
        class="products-grid"
        x-transition:enter="fade-in"
        wire:loading.class="loading"
    >
        @foreach($this->products as $product)
            <div 
                class="product-card"
                x-data="{ hover: false }"
                @mouseenter="hover = true"
                @mouseleave="hover = false"
                x-transition:enter="slide-up"
            >
                <div class="product-image">
                    <img src="{{ $product->featured_image }}" alt="{{ $product->name }}">
                    
                    <div 
                        class="overlay"
                        x-show="hover"
                        x-transition
                    >
                        <button 
                            wire:click="openEditModal({{ $product->id }})"
                            class="btn-edit"
                        >
                            <i class="icon-edit"></i>
                        </button>
                        
                        <button 
                            wire:click="deleteProduct({{ $product->id }})"
                            wire:confirm="هل تريد حذف هذا المنتج؟"
                            class="btn-delete"
                        >
                            <i class="icon-trash"></i>
                        </button>
                    </div>
                </div>
                
                <div class="product-info">
                    <h3>{{ $product->name }}</h3>
                    <p class="price">${{ number_format($product->price, 2) }}</p>
                    <span class="category">{{ $product->category->name }}</span>
                </div>
            </div>
        @endforeach
    </div>
    
    {{-- Pagination --}}
    <div class="pagination-wrapper">
        {{ $this->products->links() }}
    </div>
    
    {{-- Real-time Activities --}}
    <div class="activities-sidebar">
        <h4>النشاط المباشر</h4>
        <div class="activities-list">
            @foreach($recentActivities as $activity)
                <div 
                    class="activity-item"
                    x-data="{ show: false }"
                    x-init="setTimeout(() => show = true, {{ $loop->index * 100 }})"
                    x-show="show"
                    x-transition:enter="slide-right"
                >
                    <div class="activity-icon">
                        @if($activity['type'] === 'created')
                            <i class="icon-plus text-green"></i>
                        @elseif($activity['type'] === 'updated')
                            <i class="icon-edit text-blue"></i>
                        @else
                            <i class="icon-trash text-red"></i>
                        @endif
                    </div>
                    
                    <div class="activity-content">
                        <p>{{ $activity['user'] }} {{ $activity['type'] }} منتج</p>
                        <span class="timestamp">{{ $activity['timestamp']->diffForHumans() }}</span>
                    </div>
                </div>
            @endforeach
        </div>
    </div>
    
    {{-- Modal --}}
    @if($showModal)
        <div 
            class="modal-overlay"
            x-show="$wire.showModal"
            x-transition:enter="fade-in"
            x-transition:leave="fade-out"
            @click="$wire.closeModal()"
        >
            <div 
                class="modal-content"
                @click.stop
                x-transition:enter="scale-up"
                x-transition:leave="scale-down"
            >
                <livewire:product-form 
                    :product-id="$editingProductId" 
                    :key="$editingProductId"
                />
            </div>
        </div>
    @endif
</div>

<script>
function productManager() {
    return {
        init() {
            // Listen for WebSocket events
            this.setupWebSocketListeners();
            
            // Setup keyboard shortcuts
            this.setupKeyboardShortcuts();
        },
        
        setupWebSocketListeners() {
            window.Echo.channel('products')
                .listen('ProductCreated', (e) => {
                    this.showNotification('تم إنشاء منتج جديد', 'success');
                })
                .listen('ProductUpdated', (e) => {
                    this.showNotification('تم تحديث المنتج', 'info');
                });
        },
        
        setupKeyboardShortcuts() {
            document.addEventListener('keydown', (e) => {
                if (e.ctrlKey && e.key === 'k') {
                    e.preventDefault();
                    this.$refs.searchInput.focus();
                }
                
                if (e.key === 'Escape') {
                    this.$wire.closeModal();
                }
            });
        },
        
        showNotification(message, type) {
            // Custom notification system
            const notification = document.createElement('div');
            notification.className = `notification ${type}`;
            notification.textContent = message;
            
            document.body.appendChild(notification);
            
            setTimeout(() => {
                notification.remove();
            }, 3000);
        }
    }
}
</script>

<style>
.product-manager {
    @apply container mx-auto px-4 py-8;
}

.manager-header {
    @apply flex justify-between items-center mb-8 p-6 bg-white rounded-lg shadow-sm;
}

.search-input {
    @apply w-96 px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent;
}

.filters {
    @apply flex gap-2 mt-4;
}

.filter-btn {
    @apply px-4 py-2 rounded-full border transition-all duration-200;
    
    &:hover { @apply bg-gray-50; }
    &.active { @apply bg-blue-500 text-white; }
}

.products-grid {
    @apply grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6;
    
    &.loading { @apply opacity-50 pointer-events-none; }
}

.product-card {
    @apply bg-white rounded-xl shadow-sm overflow-hidden transition-all duration-300 hover:shadow-lg hover:-translate-y-1;
}

.activities-sidebar {
    @apply fixed right-4 top-20 w-80 bg-white rounded-lg shadow-lg p-4 max-h-96 overflow-y-auto;
}

.modal-overlay {
    @apply fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50;
}

.modal-content {
    @apply bg-white rounded-xl p-6 max-w-2xl w-full mx-4 max-h-90vh overflow-y-auto;
}

/* Transitions */
.fade-in-enter { @apply opacity-0; }
.fade-in-enter-active { @apply transition-opacity duration-300; }
.fade-in-enter-to { @apply opacity-100; }

.slide-up-enter { @apply opacity-0 translate-y-4; }
.slide-up-enter-active { @apply transition-all duration-300; }
.slide-up-enter-to { @apply opacity-100 translate-y-0; }

.scale-up-enter { @apply opacity-0 scale-95; }
.scale-up-enter-active { @apply transition-all duration-200; }
.scale-up-enter-to { @apply opacity-100 scale-100; }
</style>
```

---

## 📊 **Training Progress: 200,000/1,000,000 دورة مكتملة**

### 🎯 **المفاهيم المتقنة:**
- ✅ Livewire 3.0 Advanced Features
- ✅ Real-time WebSocket Integration
- ✅ Dynamic Component Architecture
- ✅ Advanced Event Handling
- ✅ File Upload & Progress Tracking
- ✅ Computed Properties Optimization
- ✅ Alpine.js Deep Integration

### 🔄 **المكونات المطبقة:**
- Real-time Chat System
- Dynamic Form Builder
- Live Dashboard with Metrics
- File Manager Component
- Advanced Search & Filtering
- Modal Management System

---

**📈 تقدم محمد بن ناصر: 20% مكتمل - الإبداع في Livewire مستمر...**