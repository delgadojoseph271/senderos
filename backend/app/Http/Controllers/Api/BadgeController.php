<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Badge;
use App\Models\UserBadge;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class BadgeController extends Controller
{
    public function index(Request $request): JsonResponse
    {
        $badges = Badge::orderBy('name')->get();

        $userBadges = [];
        if ($request->user()) {
            $userBadges = UserBadge::where('user_id', $request->user()->id)
                ->pluck('earned_at', 'badge_id')
                ->toArray();
        }

        $result = $badges->map(function ($badge) use ($userBadges) {
            $data = [
                'id' => $badge->id,
                'name' => $badge->name,
                'slug' => $badge->slug,
                'description' => $badge->description,
                'icon' => $badge->icon,
            ];

            if (isset($userBadges[$badge->id])) {
                $data['earned'] = true;
                $data['earned_at'] = $userBadges[$badge->id];
            } else {
                $data['earned'] = false;
                $data['earned_at'] = null;
            }

            return $data;
        });

        return response()->json($result);
    }

    public function me(Request $request): JsonResponse
    {
        $badges = UserBadge::with('badge')
            ->where('user_id', $request->user()->id)
            ->orderByDesc('earned_at')
            ->get()
            ->map(function ($userBadge) {
                return [
                    'id' => $userBadge->badge->id,
                    'name' => $userBadge->badge->name,
                    'slug' => $userBadge->badge->slug,
                    'description' => $userBadge->badge->description,
                    'icon' => $userBadge->badge->icon,
                    'earned_at' => $userBadge->earned_at,
                ];
            });

        return response()->json($badges);
    }
}
