<?php

namespace App\Http\Middleware;

use App\Models\User;
use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

class TokenAuth
{
    public function handle(Request $request, Closure $next, ?string $roles = null): Response
    {
        $token = $request->bearerToken();

        if (! $token) {
            return response()->json(['message' => 'Authentification requise.'], 401);
        }

        $user = User::query()
            ->where('api_token_hash', hash('sha256', $token))
            ->first();

        if (! $user) {
            return response()->json(['message' => 'Session invalide ou expiree.'], 401);
        }

        $allowedRoles = $roles ? explode('|', $roles) : [];

        if ($allowedRoles !== [] && ! in_array($user->role, $allowedRoles, true)) {
            return response()->json(['message' => 'Acces non autorise pour ce role.'], 403);
        }

        $request->setUserResolver(fn (): User => $user);

        return $next($request);
    }
}
