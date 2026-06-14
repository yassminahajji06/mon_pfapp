<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('restaurants', function (Blueprint $table): void {
            $table->id();
            $table->string('name');
            $table->string('address');
            $table->string('phone')->nullable();
            $table->boolean('is_open')->default(true);
            $table->unsignedInteger('delivery_fee')->default(250);
            $table->timestamps();
        });

        Schema::create('categories', function (Blueprint $table): void {
            $table->id();
            $table->string('slug')->unique();
            $table->string('label');
            $table->string('icon')->default('restaurant_menu');
            $table->string('color', 16)->default('#E53935');
            $table->unsignedSmallInteger('sort_order')->default(0);
            $table->timestamps();
        });

        Schema::create('menu_items', function (Blueprint $table): void {
            $table->id();
            $table->foreignId('restaurant_id')->constrained()->cascadeOnDelete();
            $table->foreignId('category_id')->constrained()->cascadeOnDelete();
            $table->string('slug')->unique();
            $table->string('name');
            $table->text('description');
            $table->string('image_asset')->nullable();
            $table->string('image_url')->nullable();
            $table->unsignedInteger('price');
            $table->decimal('rating', 2, 1)->default(4.5);
            $table->unsignedSmallInteger('prep_time_minutes')->default(20);
            $table->string('icon')->default('restaurant_menu');
            $table->string('color', 16)->default('#E53935');
            $table->boolean('vegetarian')->default(false);
            $table->boolean('popular')->default(false);
            $table->boolean('available')->default(true);
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('menu_items');
        Schema::dropIfExists('categories');
        Schema::dropIfExists('restaurants');
    }
};
