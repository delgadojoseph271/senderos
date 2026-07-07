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
        $payload = Cache::remember('zones.index', 300, function () {
            $zones = Zone::withCount('routes')->orderBy('name')->get();

            return ZoneResource::collection($zones)->response()->getData(true);
        });

        return response()->json($payload);
    }
}
