<?php

namespace App\Listeners;

use App\Events\BookingConfirmed;
use App\Services\BadgeEvaluatorService;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Queue\InteractsWithQueue;

class EvaluateBadges implements ShouldQueue
{
    use InteractsWithQueue;

    public function handle(BookingConfirmed $event): void
    {
        $booking = $event->booking;
        $user = $booking->user;

        app(BadgeEvaluatorService::class)->evaluate($user);
    }
}
