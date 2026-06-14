<?php

use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\MenuController;
use App\Http\Controllers\Api\OrderController;
use Illuminate\Support\Facades\Route;

Route::get('/health', fn () => response()->json([
    'status' => 'ok',
    'service' => 'mon_pfapi',
]));

Route::get('/menu', [MenuController::class, 'index']);

Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);

Route::middleware('auth.api')->group(function (): void {
    Route::post('/logout', [AuthController::class, 'logout']);

    Route::get('/orders', [OrderController::class, 'index']);
    Route::post('/orders', [OrderController::class, 'store']);
    Route::get('/orders/{order}', [OrderController::class, 'show']);
    Route::patch('/orders/{order}/status', [OrderController::class, 'updateStatus']);

    Route::middleware('auth.api:admin|serveur')->group(function (): void {
        Route::get('/admin/stats', [OrderController::class, 'stats']);
        Route::post('/admin/menu', [MenuController::class, 'store']);
        Route::patch('/admin/menu/{slug}', [MenuController::class, 'update']);
        Route::delete('/admin/menu/{slug}', [MenuController::class, 'destroy']);
        Route::patch('/admin/orders/{order}/assign-driver', [OrderController::class, 'assignDriver']);
    });

    Route::middleware('auth.api:admin|livreur')->group(function (): void {
        Route::get('/driver/orders', [OrderController::class, 'driverQueue']);
        Route::patch('/driver/orders/{order}/accept', [OrderController::class, 'acceptForDelivery']);
    });
});
