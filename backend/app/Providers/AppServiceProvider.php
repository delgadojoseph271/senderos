<?php

namespace App\Providers;

use App\Events\BookingConfirmed;
use App\Listeners\EvaluateBadges;
use Illuminate\Support\Facades\Event;
use Illuminate\Support\ServiceProvider;

class AppServiceProvider extends ServiceProvider
{
    public function register(): void
    {
        //
    }

    public function boot(): void
    {
        Event::listen(
            BookingConfirmed::class,
            EvaluateBadges::class,
        );
    }
}
