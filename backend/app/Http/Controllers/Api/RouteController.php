<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Resources\GuideResource;
use App\Http\Resources\RouteResource;
use App\Models\Route;
use Illuminate\Http\Request;

class RouteController extends Controller
{
    public function index(Request $request)
    {
        $query = Route::query()->with(['zone', 'category']);

        if ($request->filled('zone')) {
            $query->whereHas('zone', fn($q) => $q->where('slug', $request->zone));
        }

        if ($request->filled('category')) {
            $query->whereHas('category', fn($q) => $q->where('slug', $request->category));
        }

        if ($request->filled('difficulty')) {
            $query->where('difficulty', $request->difficulty);
        }

        $routes = $query->where('is_active', true)
            ->orderBy('name')
            ->get();

        return RouteResource::collection($routes);
    }

    public function show(string $slug)
    {
        $route = Route::with(['zone', 'category', 'images', 'guides'])
            ->where('slug', $slug)
            ->where('is_active', true)
            ->firstOrFail();

        return new RouteResource($route);
    }

    public function guides(string $slug)
    {
        $route = Route::with('guides')
            ->where('slug', $slug)
            ->where('is_active', true)
            ->firstOrFail();

        return GuideResource::collection($route->guides);
    }
}
