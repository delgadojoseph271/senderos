<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Resources\GuideResource;
use App\Models\Guide;
use Illuminate\Http\Request;

class GuideController extends Controller
{
    public function index(Request $request)
    {
        $guides = Guide::orderBy('name')->paginate($request->integer('per_page', 50));

        return GuideResource::collection($guides);
    }
}
