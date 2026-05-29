<?php

namespace App\Services;

use App\Models\Badge;
use App\Models\Booking;
use App\Models\User;
use App\Models\UserBadge;
use Illuminate\Support\Facades\DB;

class BadgeEvaluatorService
{
    public function evaluate(User $user): void
    {
        $badges = Badge::all();

        foreach ($badges as $badge) {
            $alreadyEarned = UserBadge::where('user_id', $user->id)
                ->where('badge_id', $badge->id)
                ->exists();

            if ($alreadyEarned) {
                continue;
            }

            $value = $this->calculateConditionValue($user, $badge->condition_type);

            if ($value >= $badge->condition_value) {
                UserBadge::create([
                    'user_id' => $user->id,
                    'badge_id' => $badge->id,
                    'earned_at' => now(),
                ]);
            }
        }
    }

    private function calculateConditionValue(User $user, string $conditionType): int
    {
        if ($conditionType === 'bookings_count') {
            return Booking::where('user_id', $user->id)
                ->where('status', 'confirmed')
                ->count();
        }

        if ($conditionType === 'zones_visited') {
            return Booking::where('user_id', $user->id)
                ->where('status', 'confirmed')
                ->join('routes', 'bookings.route_id', '=', 'routes.id')
                ->distinct('routes.zone_id')
                ->count('routes.zone_id');
        }

        if (str_starts_with($conditionType, 'category_count:')) {
            $slug = str_replace('category_count:', '', $conditionType);

            return Booking::where('user_id', $user->id)
                ->where('status', 'confirmed')
                ->join('routes', 'bookings.route_id', '=', 'routes.id')
                ->join('categories', 'routes.category_id', '=', 'categories.id')
                ->where('categories.slug', $slug)
                ->count();
        }

        return 0;
    }
}
