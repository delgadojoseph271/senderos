<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\WeatherCache;
use App\Models\Zone;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Http;

class WeatherController extends Controller
{
    public function show(string $slug): JsonResponse
    {
        $zone = Zone::where('slug', $slug)->firstOrFail();

        if (!$zone->lat || !$zone->lng) {
            return response()->json([
                'zone' => $zone->name,
                'error' => 'Coordenadas no disponibles para esta zona.',
            ], 404);
        }

        $cached = WeatherCache::where('zone_id', $zone->id)
            ->latest('fetched_at')
            ->first();

        $stale = false;

        if ($cached && $cached->fetched_at->diffInHours(now()) < 1) {
            return $this->buildResponse($zone, $cached, false);
        }

        try {
            $response = Http::timeout(5)->get('https://api.open-meteo.com/v1/forecast', [
                'latitude' => $zone->lat,
                'longitude' => $zone->lng,
                'current' => 'temperature_2m,precipitation,weathercode',
                'timezone' => 'America/Panama',
            ]);

            if ($response->failed()) {
                throw new \Exception('Open-Meteo request failed');
            }

            $data = $response->json('current');
            $temp = $data['temperature_2m'] ?? 0;
            $rain = $data['precipitation'] ?? 0;
            $code = $data['weathercode'] ?? 0;
            $risk = $this->calculateRiskLevel($rain, $code);

            $weather = WeatherCache::updateOrCreate(
                ['zone_id' => $zone->id],
                [
                    'temp_c' => $temp,
                    'rain_mm' => $rain,
                    'risk_level' => $risk,
                    'fetched_at' => now(),
                ]
            );

            return $this->buildResponse($zone, $weather, false);
        } catch (\Exception $e) {
            if ($cached) {
                return $this->buildResponse($zone, $cached, true);
            }

            return response()->json([
                'zone' => $zone->name,
                'error' => 'No se pudo obtener el clima.',
            ], 503);
        }
    }

    private function calculateRiskLevel(float $rain, int $code): string
    {
        if ($rain > 10 || $code >= 80) {
            return 'alto';
        }

        if ($rain >= 2 || ($code >= 61 && $code <= 79)) {
            return 'medio';
        }

        return 'bajo';
    }

    private function buildResponse(Zone $zone, WeatherCache $weather, bool $stale): JsonResponse
    {
        $data = [
            'zone' => $zone->name,
            'temp_c' => (float) $weather->temp_c,
            'rain_mm' => (float) $weather->rain_mm,
            'risk_level' => $weather->risk_level,
            'fetched_at' => $weather->fetched_at->toIso8601String(),
        ];

        if ($stale) {
            $data['stale'] = true;
        }

        return response()->json($data);
    }
}
