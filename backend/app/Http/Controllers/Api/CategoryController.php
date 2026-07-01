<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Resources\CategoryResource;
use App\Models\Category;
use Illuminate\Support\Facades\Cache;

class CategoryController extends Controller
{
    public function index()
    {
        $categories = Cache::remember('categories.index', 300, fn () => Category::withCount('routes')->orderBy('name')->get());

        return CategoryResource::collection($categories);
    }
}
