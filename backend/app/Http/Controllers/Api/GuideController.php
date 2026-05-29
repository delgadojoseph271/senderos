<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Resources\GuideResource;
use App\Models\Guide;

class GuideController extends Controller
{
    public function index()
    {
        $guides = Guide::orderBy('name')->get();

        return GuideResource::collection($guides);
    }
}
