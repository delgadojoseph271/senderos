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
        $payload = Cache::remember('categories.index', 300, function () {
            $categories = Category::withCount('routes')->orderBy('name')->get();

            return CategoryResource::collection($categories)->response()->getData(true);
        });

        return response()->json($payload);
    }
}
