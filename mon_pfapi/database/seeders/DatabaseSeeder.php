<?php

namespace Database\Seeders;

use App\Models\Category;
use App\Models\MenuItem;
use App\Models\Order;
use App\Models\Restaurant;
use App\Models\User;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;

class DatabaseSeeder extends Seeder
{
    public function run(): void
    {
        $users = [
            [
                'name' => 'Yassmine Hajji',
                'email' => 'yassmine@monpf.fr',
                'role' => 'client',
                'phone' => '+213 555 010 100',
                'address' => '12 Rue Didouche Mourad, Alger Centre',
            ],
            [
                'name' => 'Admin Mon PF',
                'email' => 'admin@monpf.fr',
                'role' => 'admin',
                'phone' => '+213 555 010 200',
                'address' => 'Restaurant Mon PF',
            ],
            [
                'name' => 'Serveur Mon PF',
                'email' => 'serveur@monpf.fr',
                'role' => 'serveur',
                'phone' => '+213 555 010 201',
                'address' => 'Salle principale',
            ],
            [
                'name' => 'Livreur Mon PF',
                'email' => 'livreur@monpf.fr',
                'role' => 'livreur',
                'phone' => '+213 555 010 300',
                'address' => 'Zone Alger Centre',
            ],
        ];

        foreach ($users as $user) {
            User::query()->updateOrCreate(
                ['email' => $user['email']],
                [
                    ...$user,
                    'password' => Hash::make('password'),
                    'api_token_hash' => null,
                ],
            );
        }

        $restaurant = Restaurant::query()->updateOrCreate(
            ['name' => 'Mon PF Restaurant'],
            [
                'address' => 'Avenue de la Gastronomie, Alger Centre',
                'phone' => '+213 555 010 000',
                'is_open' => true,
                'delivery_fee' => 250,
            ],
        );

        $categories = [
            ['slug' => 'entrees', 'label' => 'Entrees', 'icon' => 'soup_kitchen_outlined', 'color' => '#FB8C00', 'sort_order' => 1],
            ['slug' => 'plats', 'label' => 'Plats', 'icon' => 'restaurant_menu', 'color' => '#E53935', 'sort_order' => 2],
            ['slug' => 'poissons', 'label' => 'Poissons', 'icon' => 'set_meal_outlined', 'color' => '#1E88E5', 'sort_order' => 3],
            ['slug' => 'desserts', 'label' => 'Desserts', 'icon' => 'cake_outlined', 'color' => '#8E24AA', 'sort_order' => 4],
            ['slug' => 'boissons', 'label' => 'Boissons', 'icon' => 'local_cafe_outlined', 'color' => '#43A047', 'sort_order' => 5],
        ];

        $categoryModels = [];

        foreach ($categories as $category) {
            $categoryModels[$category['slug']] = Category::query()->updateOrCreate(
                ['slug' => $category['slug']],
                $category,
            );
        }

        $menuItems = [
            [
                'slug' => 'soupe-oignon',
                'name' => "Soupe a l'oignon",
                'category' => 'entrees',
                'description' => 'Oignons confits, bouillon maison et fromage gratine.',
                'image_asset' => 'assets/menu/soupe-oignon.jpg',
                'price' => 450,
                'rating' => 4.7,
                'prep_time_minutes' => 15,
                'icon' => 'soup_kitchen_outlined',
                'color' => '#FB8C00',
            ],
            [
                'slug' => 'foie-gras',
                'name' => 'Foie gras maison',
                'category' => 'entrees',
                'description' => 'Servi avec confiture de figues et pain grille.',
                'image_asset' => 'assets/menu/foie-gras.jpg',
                'price' => 780,
                'rating' => 4.9,
                'prep_time_minutes' => 12,
                'icon' => 'breakfast_dining_outlined',
                'color' => '#795548',
                'popular' => true,
            ],
            [
                'slug' => 'coq-vin',
                'name' => 'Coq au Vin',
                'category' => 'plats',
                'description' => 'Poulet braise au vin rouge, champignons et carottes.',
                'image_asset' => 'assets/menu/coq-vin.jpg',
                'price' => 890,
                'rating' => 4.8,
                'prep_time_minutes' => 25,
                'icon' => 'dinner_dining',
                'color' => '#E53935',
                'popular' => true,
            ],
            [
                'slug' => 'boeuf-bourguignon',
                'name' => 'Boeuf Bourguignon',
                'category' => 'plats',
                'description' => 'Boeuf mijote, sauce riche et legumes fondants.',
                'image_asset' => 'assets/menu/boeuf-bourguignon.jpg',
                'price' => 1100,
                'rating' => 4.6,
                'prep_time_minutes' => 30,
                'icon' => 'lunch_dining',
                'color' => '#B71C1C',
            ],
            [
                'slug' => 'ratatouille',
                'name' => 'Ratatouille',
                'category' => 'plats',
                'description' => 'Legumes du soleil, herbes de Provence et huile olive.',
                'image_asset' => 'assets/menu/ratatouille.jpg',
                'price' => 680,
                'rating' => 4.5,
                'prep_time_minutes' => 20,
                'icon' => 'eco_outlined',
                'color' => '#43A047',
                'vegetarian' => true,
            ],
            [
                'slug' => 'bouillabaisse',
                'name' => 'Bouillabaisse',
                'category' => 'poissons',
                'description' => 'Soupe provencale de poissons, rouille et croutons.',
                'image_asset' => 'assets/menu/bouillabaisse.jpg',
                'price' => 1200,
                'rating' => 4.9,
                'prep_time_minutes' => 35,
                'icon' => 'set_meal_outlined',
                'color' => '#1E88E5',
                'popular' => true,
            ],
            [
                'slug' => 'creme-brulee',
                'name' => 'Creme Brulee',
                'category' => 'desserts',
                'description' => 'Creme vanille et fine couche de caramel croquant.',
                'image_asset' => 'assets/menu/creme-brulee.jpg',
                'price' => 350,
                'rating' => 4.7,
                'prep_time_minutes' => 10,
                'icon' => 'cake_outlined',
                'color' => '#8E24AA',
                'vegetarian' => true,
            ],
            [
                'slug' => 'tarte-tatin',
                'name' => 'Tarte Tatin',
                'category' => 'desserts',
                'description' => 'Pommes caramelisees et pate croustillante.',
                'image_asset' => 'assets/menu/tarte-tatin.jpg',
                'price' => 320,
                'rating' => 4.8,
                'prep_time_minutes' => 10,
                'icon' => 'bakery_dining_outlined',
                'color' => '#F57C00',
                'vegetarian' => true,
            ],
            [
                'slug' => 'citronnade',
                'name' => 'Citronnade maison',
                'category' => 'boissons',
                'description' => 'Citron frais, menthe et eau petillante.',
                'image_asset' => 'assets/menu/citronnade.jpg',
                'price' => 180,
                'rating' => 4.4,
                'prep_time_minutes' => 5,
                'icon' => 'local_drink_outlined',
                'color' => '#43A047',
                'vegetarian' => true,
            ],
        ];

        foreach ($menuItems as $item) {
            MenuItem::query()->updateOrCreate(
                ['slug' => $item['slug']],
                [
                    'restaurant_id' => $restaurant->id,
                    'category_id' => $categoryModels[$item['category']]->id,
                    'name' => $item['name'],
                    'description' => $item['description'],
                    'image_asset' => $item['image_asset'],
                    'price' => $item['price'],
                    'rating' => $item['rating'],
                    'prep_time_minutes' => $item['prep_time_minutes'],
                    'icon' => $item['icon'],
                    'color' => $item['color'],
                    'vegetarian' => $item['vegetarian'] ?? false,
                    'popular' => $item['popular'] ?? false,
                    'available' => true,
                ],
            );
        }

        $client = User::query()->where('email', 'yassmine@monpf.fr')->firstOrFail();
        $driver = User::query()->where('email', 'livreur@monpf.fr')->firstOrFail();
        $coq = MenuItem::query()->where('slug', 'coq-vin')->firstOrFail();
        $creme = MenuItem::query()->where('slug', 'creme-brulee')->firstOrFail();

        $order = Order::query()->updateOrCreate(
            ['code' => '#PF-0847'],
            [
                'user_id' => $client->id,
                'restaurant_id' => $restaurant->id,
                'assigned_driver_id' => $driver->id,
                'customer_name' => $client->name,
                'customer_phone' => $client->phone,
                'address' => $client->address,
                'status' => Order::STATUS_DELIVERED,
                'payment_method' => 'cash',
                'subtotal' => 2130,
                'delivery_fee' => 250,
                'total' => 2380,
                'estimated_minutes' => 30,
                'ordered_at' => now()->subHours(2),
            ],
        );

        $order->items()->delete();
        $order->items()->createMany([
            [
                'menu_item_id' => $coq->id,
                'item_name' => $coq->name,
                'unit_price' => $coq->price,
                'quantity' => 2,
                'line_total' => $coq->price * 2,
            ],
            [
                'menu_item_id' => $creme->id,
                'item_name' => $creme->name,
                'unit_price' => $creme->price,
                'quantity' => 1,
                'line_total' => $creme->price,
            ],
        ]);
    }
}
