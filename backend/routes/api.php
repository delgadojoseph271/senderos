<?php

use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\BadgeController;
use App\Http\Controllers\Api\BookingController;
use App\Http\Controllers\Api\CategoryController;
use App\Http\Controllers\Api\GuideController;
use App\Http\Controllers\Api\RouteController;
use App\Http\Controllers\Api\WeatherController;
use App\Http\Controllers\Api\ZoneController;
use Illuminate\Support\Facades\Route;

Route::prefix('v1')->group(function () {

    // Auth
    Route::prefix('auth')->group(function () {
        Route::post('register', [AuthController::class, 'register']);
        Route::post('login', [AuthController::class, 'login']);
        Route::post('logout', [AuthController::class, 'logout'])->middleware('auth:sanctum');
        Route::get('me', [AuthController::class, 'me'])->middleware('auth:sanctum');
    });

    // Fase 1 — Catálogo público
    Route::get('zones', [ZoneController::class, 'index']);
    Route::get('zones/{slug}/weather', [WeatherController::class, 'show']);
    Route::get('categories', [CategoryController::class, 'index']);
    Route::get('routes', [RouteController::class, 'index']);
    Route::get('routes/{slug}', [RouteController::class, 'show']);
    Route::get('routes/{slug}/guides', [RouteController::class, 'guides']);
    Route::get('guides', [GuideController::class, 'index']);

    // Bookings (auth required)
    Route::middleware('auth:sanctum')->group(function () {
        Route::apiResource('bookings', BookingController::class)->only(['index', 'store', 'show', 'destroy']);
        Route::get('me/badges', [BadgeController::class, 'me']);
    });

    // Badges (público)
    Route::get('badges', [BadgeController::class, 'index']);
});
