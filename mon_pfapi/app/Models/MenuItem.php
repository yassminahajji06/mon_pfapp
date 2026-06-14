<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

class MenuItem extends Model
{
    use HasFactory;

    protected $fillable = [
        'restaurant_id',
        'category_id',
        'slug',
        'name',
        'description',
        'image_asset',
        'image_url',
        'price',
        'rating',
        'prep_time_minutes',
        'icon',
        'color',
        'vegetarian',
        'popular',
        'available',
    ];

    protected function casts(): array
    {
        return [
            'rating' => 'float',
            'vegetarian' => 'boolean',
            'popular' => 'boolean',
            'available' => 'boolean',
        ];
    }

    public function restaurant(): BelongsTo
    {
        return $this->belongsTo(Restaurant::class);
    }

    public function category(): BelongsTo
    {
        return $this->belongsTo(Category::class);
    }

    public function orderItems(): HasMany
    {
        return $this->hasMany(OrderItem::class);
    }
}
