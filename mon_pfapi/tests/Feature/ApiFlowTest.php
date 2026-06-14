<?php

namespace Tests\Feature;

use App\Models\User;
use Database\Seeders\DatabaseSeeder;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class ApiFlowTest extends TestCase
{
    use RefreshDatabase;

    public function test_public_menu_returns_seeded_catalog(): void
    {
        $this->seed(DatabaseSeeder::class);

        $this->getJson('/api/menu')
            ->assertOk()
            ->assertJsonCount(5, 'categories')
            ->assertJsonCount(9, 'items');
    }

    public function test_login_returns_token_and_user_role(): void
    {
        $this->seed(DatabaseSeeder::class);

        $this->postJson('/api/login', [
            'email' => 'yassmine@monpf.fr',
            'mot_de_passe' => 'password',
        ])
            ->assertOk()
            ->assertJsonPath('user.role', 'client')
            ->assertJsonStructure(['token', 'user' => ['id', 'nom', 'email', 'role']]);
    }

    public function test_registration_ignores_public_role_and_forces_client(): void
    {
        $this->postJson('/api/register', [
            'nom' => 'Client Demo',
            'email' => 'client.demo@monpf.fr',
            'mot_de_passe' => 'password',
            'role' => 'admin',
        ])
            ->assertCreated()
            ->assertJsonPath('user.role', 'client');

        $this->assertSame('client', User::query()->where('email', 'client.demo@monpf.fr')->value('role'));
    }

    public function test_authenticated_client_can_create_order(): void
    {
        $this->seed(DatabaseSeeder::class);

        $token = $this->postJson('/api/login', [
            'email' => 'yassmine@monpf.fr',
            'mot_de_passe' => 'password',
        ])->json('token');

        $this->withToken($token)->postJson('/api/orders', [
            'address' => '12 Rue Didouche Mourad, Alger Centre',
            'payment_method' => 'cash',
            'items' => [
                ['menu_item_id' => 'coq-vin', 'quantity' => 1],
                ['menu_item_id' => 'citronnade', 'quantity' => 1],
            ],
        ])
            ->assertCreated()
            ->assertJsonPath('order.statusKey', 'preparation')
            ->assertJsonPath('order.amount', 1320)
            ->assertJsonCount(2, 'order.items');
    }
}
