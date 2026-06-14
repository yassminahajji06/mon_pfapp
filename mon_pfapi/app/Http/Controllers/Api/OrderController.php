<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\MenuItem;
use App\Models\Order;
use App\Models\Restaurant;
use App\Models\User;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Validation\Rule;

class OrderController extends Controller
{
    private const STATUS_LABELS = [
        Order::STATUS_PREPARATION => 'Preparation',
        Order::STATUS_READY => 'Pret',
        Order::STATUS_DELIVERING => 'En route',
        Order::STATUS_DELIVERED => 'Livre',
        Order::STATUS_CANCELLED => 'Annule',
    ];

    public function index(Request $request): JsonResponse
    {
        $user = $request->user();
        $query = Order::query()
            ->with(['user', 'driver', 'items'])
            ->latest();

        if ($user->role === 'client') {
            $query->where('user_id', $user->id);
        } elseif ($user->role === 'livreur') {
            $query->where('assigned_driver_id', $user->id);
        }

        return response()->json([
            'orders' => $query->get()->map(fn (Order $order): array => $this->serializeOrder($order)),
        ]);
    }

    public function store(Request $request): JsonResponse
    {
        $user = $request->user();
        $data = $request->validate([
            'address' => ['required', 'string', 'max:240'],
            'phone' => ['nullable', 'string', 'max:40'],
            'notes' => ['nullable', 'string', 'max:1000'],
            'payment_method' => ['nullable', Rule::in(['cash', 'card'])],
            'items' => ['required', 'array', 'min:1'],
            'items.*.menu_item_id' => ['required', 'string', 'max:160'],
            'items.*.quantity' => ['required', 'integer', 'min:1', 'max:20'],
        ]);

        $restaurant = Restaurant::query()->firstOrFail();
        $preparedItems = [];
        $subtotal = 0;

        foreach ($data['items'] as $line) {
            $menuItem = MenuItem::query()
                ->where('slug', $line['menu_item_id'])
                ->where('available', true)
                ->firstOrFail();

            $quantity = (int) $line['quantity'];
            $lineTotal = $menuItem->price * $quantity;
            $subtotal += $lineTotal;

            $preparedItems[] = [
                'menu_item_id' => $menuItem->id,
                'item_name' => $menuItem->name,
                'unit_price' => $menuItem->price,
                'quantity' => $quantity,
                'line_total' => $lineTotal,
            ];
        }

        $order = DB::transaction(function () use ($data, $user, $restaurant, $preparedItems, $subtotal): Order {
            $deliveryFee = $restaurant->delivery_fee;
            $order = Order::query()->create([
                'code' => $this->nextCode(),
                'user_id' => $user->id,
                'restaurant_id' => $restaurant->id,
                'customer_name' => $user->name,
                'customer_phone' => $data['phone'] ?? $user->phone,
                'address' => $data['address'],
                'notes' => $data['notes'] ?? null,
                'status' => Order::STATUS_PREPARATION,
                'payment_method' => $data['payment_method'] ?? 'cash',
                'subtotal' => $subtotal,
                'delivery_fee' => $deliveryFee,
                'total' => $subtotal + $deliveryFee,
                'estimated_minutes' => 35,
                'ordered_at' => now(),
            ]);

            $order->items()->createMany($preparedItems);

            return $order->load(['user', 'driver', 'items']);
        });

        return response()->json(['order' => $this->serializeOrder($order)], 201);
    }

    public function show(Request $request, Order $order): JsonResponse
    {
        if (! $this->canAccess($request->user(), $order)) {
            return response()->json(['message' => 'Commande non autorisee.'], 403);
        }

        return response()->json(['order' => $this->serializeOrder($order->load(['user', 'driver', 'items']))]);
    }

    public function updateStatus(Request $request, Order $order): JsonResponse
    {
        $user = $request->user();

        if (! $this->canAccess($user, $order) && ! in_array($user->role, ['admin', 'serveur'], true)) {
            return response()->json(['message' => 'Commande non autorisee.'], 403);
        }

        $data = $request->validate([
            'status' => ['required', 'string'],
        ]);

        $status = $this->normalizeStatus($data['status']);

        if (! $status) {
            return response()->json(['message' => 'Statut invalide.'], 422);
        }

        if ($user->role === 'livreur' && ! in_array($status, [Order::STATUS_DELIVERING, Order::STATUS_DELIVERED], true)) {
            return response()->json(['message' => 'Statut non autorise pour livreur.'], 403);
        }

        $order->update(['status' => $status]);

        return response()->json(['order' => $this->serializeOrder($order->refresh()->load(['user', 'driver', 'items']))]);
    }

    public function assignDriver(Request $request, Order $order): JsonResponse
    {
        $data = $request->validate([
            'driver_id' => [
                'required',
                Rule::exists('users', 'id')->where(fn ($query) => $query->where('role', 'livreur')),
            ],
        ]);

        $order->update([
            'assigned_driver_id' => $data['driver_id'],
            'status' => Order::STATUS_DELIVERING,
        ]);

        return response()->json(['order' => $this->serializeOrder($order->refresh()->load(['user', 'driver', 'items']))]);
    }

    public function driverQueue(Request $request): JsonResponse
    {
        $user = $request->user();
        $orders = Order::query()
            ->with(['user', 'driver', 'items'])
            ->whereIn('status', [
                Order::STATUS_PREPARATION,
                Order::STATUS_READY,
                Order::STATUS_DELIVERING,
            ])
            ->where(function ($query) use ($user): void {
                $query->whereNull('assigned_driver_id')
                    ->orWhere('assigned_driver_id', $user->id);
            })
            ->latest()
            ->get();

        return response()->json([
            'orders' => $orders->map(fn (Order $order): array => $this->serializeOrder($order)),
        ]);
    }

    public function acceptForDelivery(Request $request, Order $order): JsonResponse
    {
        $order->update([
            'assigned_driver_id' => $request->user()->id,
            'status' => Order::STATUS_DELIVERING,
        ]);

        return response()->json(['order' => $this->serializeOrder($order->refresh()->load(['user', 'driver', 'items']))]);
    }

    public function stats(): JsonResponse
    {
        $orders = Order::query();

        return response()->json([
            'stats' => [
                'ordersCount' => (clone $orders)->count(),
                'inProgressCount' => Order::query()->whereIn('status', [
                    Order::STATUS_PREPARATION,
                    Order::STATUS_READY,
                    Order::STATUS_DELIVERING,
                ])->count(),
                'deliveredCount' => Order::query()->where('status', Order::STATUS_DELIVERED)->count(),
                'revenue' => Order::query()->where('status', Order::STATUS_DELIVERED)->sum('total'),
                'menuItemsCount' => MenuItem::query()->where('available', true)->count(),
                'clientsCount' => User::query()->where('role', 'client')->count(),
            ],
        ]);
    }

    private function nextCode(): string
    {
        $number = Order::query()->count() + 850;

        do {
            $code = '#PF-'.str_pad((string) $number, 4, '0', STR_PAD_LEFT);
            $number++;
        } while (Order::query()->where('code', $code)->exists());

        return $code;
    }

    private function normalizeStatus(string $status): ?string
    {
        $normalized = strtolower(trim($status));
        $byLabel = [];

        foreach (self::STATUS_LABELS as $key => $label) {
            $byLabel[strtolower($label)] = $key;
        }

        return match ($normalized) {
            'preparation', 'préparation' => Order::STATUS_PREPARATION,
            'ready', 'pret', 'prêt' => Order::STATUS_READY,
            'delivering', 'en route' => Order::STATUS_DELIVERING,
            'delivered', 'livre', 'livré' => Order::STATUS_DELIVERED,
            'cancelled', 'annule', 'annulé' => Order::STATUS_CANCELLED,
            default => $byLabel[$normalized] ?? null,
        };
    }

    private function canAccess(User $user, Order $order): bool
    {
        return in_array($user->role, ['admin', 'serveur'], true)
            || $order->user_id === $user->id
            || $order->assigned_driver_id === $user->id;
    }

    private function serializeOrder(Order $order): array
    {
        return [
            'id' => $order->code,
            'databaseId' => $order->id,
            'client' => $order->customer_name,
            'address' => $order->address,
            'status' => self::STATUS_LABELS[$order->status] ?? $order->status,
            'statusKey' => $order->status,
            'time' => optional($order->ordered_at ?? $order->created_at)->format('H:i'),
            'amount' => $order->total,
            'subtotal' => $order->subtotal,
            'deliveryFee' => $order->delivery_fee,
            'estimatedMinutes' => $order->estimated_minutes,
            'driver' => $order->driver ? [
                'id' => $order->driver->id,
                'nom' => $order->driver->name,
                'email' => $order->driver->email,
            ] : null,
            'items' => $order->items->map(fn ($item): array => [
                'name' => $item->item_name,
                'unitPrice' => $item->unit_price,
                'quantity' => $item->quantity,
                'lineTotal' => $item->line_total,
            ]),
        ];
    }
}
