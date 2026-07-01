<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Resources\ZoneResource;
use App\Models\Zone;
use Illuminate\Support\Facades\Cache;

class ZoneController extends Controller
{
    public function index()
    {
        $zones = Cache::remember('zones.index', 300, fn () => Zone::withCount('routes')->orderBy('name')->get());

        return ZoneResource::collection($zones);
    }
}
