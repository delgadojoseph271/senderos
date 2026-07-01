<?php

namespace App\Listeners;

use App\Events\BookingConfirmed;
use App\Services\BadgeEvaluatorService;

class EvaluateBadges
{
    public function handle(BookingConfirmed $event): void
    {
        $booking = $event->booking;
        $user = $booking->user;

        app(BadgeEvaluatorService::class)->evaluate($user);
    }
}
