<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Str;

class AuthController extends Controller
{
    public function register(Request $request): JsonResponse
    {
        $data = $request->validate([
            'nom' => ['required', 'string', 'max:120'],
            'email' => ['required', 'email', 'max:180', 'unique:users,email'],
            'mot_de_passe' => ['required', 'string', 'min:6'],
            'phone' => ['nullable', 'string', 'max:40'],
            'address' => ['nullable', 'string', 'max:240'],
        ]);

        $user = User::query()->create([
            'name' => $data['nom'],
            'email' => strtolower($data['email']),
            'phone' => $data['phone'] ?? null,
            'address' => $data['address'] ?? null,
            'role' => 'client',
            'password' => Hash::make($data['mot_de_passe']),
        ]);

        return response()->json($this->issueToken($user), 201);
    }

    public function login(Request $request): JsonResponse
    {
        $data = $request->validate([
            'email' => ['required', 'email'],
            'mot_de_passe' => ['required', 'string'],
        ]);

        $user = User::query()
            ->where('email', strtolower($data['email']))
            ->first();

        if (! $user || ! Hash::check($data['mot_de_passe'], $user->password)) {
            return response()->json(['message' => 'Email ou mot de passe incorrect.'], 401);
        }

        return response()->json($this->issueToken($user));
    }

    public function logout(Request $request): JsonResponse
    {
        $request->user()->forceFill(['api_token_hash' => null])->save();

        return response()->json(['message' => 'Deconnexion reussie.']);
    }

    private function issueToken(User $user): array
    {
        $token = Str::random(80);
        $user->forceFill(['api_token_hash' => hash('sha256', $token)])->save();

        return [
            'token' => $token,
            'user' => $this->serializeUser($user),
        ];
    }

    private function serializeUser(User $user): array
    {
        return [
            'id' => $user->id,
            'nom' => $user->name,
            'email' => $user->email,
            'role' => $user->role,
            'phone' => $user->phone,
            'address' => $user->address,
        ];
    }
}
