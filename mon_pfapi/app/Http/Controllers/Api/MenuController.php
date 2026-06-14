<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Category;
use App\Models\MenuItem;
use App\Models\Restaurant;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Str;
use Illuminate\Validation\Rule;

class MenuController extends Controller
{
    public function index(): JsonResponse
    {
        $restaurant = Restaurant::query()->first();
        $categories = Category::query()
            ->orderBy('sort_order')
            ->get()
            ->map(fn (Category $category): array => [
                'id' => $category->slug,
                'label' => $category->label,
                'icon' => $category->icon,
                'color' => $category->color,
            ]);

        $items = MenuItem::query()
            ->with('category')
            ->where('available', true)
            ->orderByDesc('popular')
            ->orderBy('name')
            ->get()
            ->map(fn (MenuItem $item): array => $this->serializeItem($item));

        return response()->json([
            'restaurant' => $restaurant ? [
                'id' => $restaurant->id,
                'name' => $restaurant->name,
                'address' => $restaurant->address,
                'phone' => $restaurant->phone,
                'isOpen' => $restaurant->is_open,
                'deliveryFee' => $restaurant->delivery_fee,
            ] : null,
            'categories' => $categories,
            'items' => $items,
        ]);
    }

    public function store(Request $request): JsonResponse
    {
        $data = $request->validate($this->rules());
        $restaurant = Restaurant::query()->firstOrFail();
        $category = Category::query()->where('slug', $data['category'])->firstOrFail();

        $item = MenuItem::query()->create($this->payload($data, $restaurant->id, $category->id));

        return response()->json(['item' => $this->serializeItem($item->load('category'))], 201);
    }

    public function update(Request $request, string $slug): JsonResponse
    {
        $item = MenuItem::query()->with('category')->where('slug', $slug)->firstOrFail();
        $data = $request->validate($this->rules(update: true));
        $data = [
            'name' => $item->name,
            'category' => $item->category->slug,
            'description' => $item->description,
            'image_asset' => $item->image_asset,
            'image_url' => $item->image_url,
            'price' => $item->price,
            'rating' => $item->rating,
            'prep_time_minutes' => $item->prep_time_minutes,
            'icon' => $item->icon,
            'color' => $item->color,
            'vegetarian' => $item->vegetarian,
            'popular' => $item->popular,
            'available' => $item->available,
            ...$data,
        ];

        $category = Category::query()->where('slug', $data['category'])->firstOrFail();
        $item->update($this->payload($data, $item->restaurant_id, $category->id, update: true));

        return response()->json(['item' => $this->serializeItem($item->refresh()->load('category'))]);
    }

    public function destroy(string $slug): JsonResponse
    {
        $item = MenuItem::query()->where('slug', $slug)->firstOrFail();
        $item->update(['available' => false]);

        return response()->json(['message' => 'Plat retire du menu actif.']);
    }

    private function rules(bool $update = false): array
    {
        $required = $update ? 'sometimes' : 'required';

        return [
            'name' => [$required, 'string', 'max:160'],
            'category' => [$required, 'string', Rule::exists('categories', 'slug')],
            'description' => [$required, 'string', 'max:1000'],
            'image_asset' => ['nullable', 'string', 'max:240'],
            'image_url' => ['nullable', 'url', 'max:500'],
            'price' => [$required, 'integer', 'min:1'],
            'rating' => ['nullable', 'numeric', 'between:0,5'],
            'prep_time_minutes' => ['nullable', 'integer', 'min:1', 'max:180'],
            'icon' => ['nullable', 'string', 'max:80'],
            'color' => ['nullable', 'string', 'max:16'],
            'vegetarian' => ['nullable', 'boolean'],
            'popular' => ['nullable', 'boolean'],
            'available' => ['nullable', 'boolean'],
        ];
    }

    private function payload(array $data, int $restaurantId, int $categoryId, bool $update = false): array
    {
        $payload = [
            'restaurant_id' => $restaurantId,
            'category_id' => $categoryId,
            'name' => $data['name'],
            'description' => $data['description'],
            'image_asset' => $data['image_asset'] ?? null,
            'image_url' => $data['image_url'] ?? null,
            'price' => $data['price'],
            'rating' => $data['rating'] ?? 4.5,
            'prep_time_minutes' => $data['prep_time_minutes'] ?? 20,
            'icon' => $data['icon'] ?? 'restaurant_menu',
            'color' => $data['color'] ?? '#E53935',
            'vegetarian' => $data['vegetarian'] ?? false,
            'popular' => $data['popular'] ?? false,
            'available' => $data['available'] ?? true,
        ];

        if (! $update) {
            $payload['slug'] = Str::slug($data['name']);
        }

        return $payload;
    }

    private function serializeItem(MenuItem $item): array
    {
        return [
            'id' => $item->slug,
            'name' => $item->name,
            'category' => $item->category?->slug,
            'description' => $item->description,
            'imageAsset' => $item->image_asset,
            'imageUrl' => $item->image_url,
            'price' => $item->price,
            'rating' => $item->rating,
            'prepTime' => $item->prep_time_minutes.' min',
            'prepTimeMinutes' => $item->prep_time_minutes,
            'icon' => $item->icon,
            'color' => $item->color,
            'vegetarian' => $item->vegetarian,
            'popular' => $item->popular,
            'available' => $item->available,
        ];
    }
}
