<?php

namespace Database\Seeders;

use App\Models\RouteGuide;
use Illuminate\Database\Seeder;

class RouteGuideSeeder extends Seeder
{
    public function run(): void
    {
        $pivots = [
            ['route_id' => 1, 'guide_id' => 1],
            ['route_id' => 1, 'guide_id' => 4],
            ['route_id' => 2, 'guide_id' => 1],
            ['route_id' => 3, 'guide_id' => 6],
            ['route_id' => 4, 'guide_id' => 6],
            ['route_id' => 5, 'guide_id' => 4],
            ['route_id' => 6, 'guide_id' => 3],
            ['route_id' => 7, 'guide_id' => 5],
            ['route_id' => 8, 'guide_id' => 5],
            ['route_id' => 9, 'guide_id' => 2],
            ['route_id' => 10, 'guide_id' => 6],
        ];

        foreach ($pivots as $pivot) {
            RouteGuide::create($pivot);
        }
    }
}
