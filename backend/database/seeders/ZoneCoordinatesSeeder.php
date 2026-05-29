<?php

namespace Database\Seeders;

use App\Models\Zone;
use Illuminate\Database\Seeder;

class ZoneCoordinatesSeeder extends Seeder
{
    public function run(): void
    {
        $coordinates = [
            'boquete' => [8.7833, -82.4500],
            'volcan' => [8.7667, -82.6333],
            'gualaca' => [8.6500, -82.3167],
            'david' => [8.4333, -82.4333],
            'boca-chica' => [7.8333, -81.7667],
            'tierras-altas' => [8.8500, -82.6000],
            'san-lorenzo' => [8.2150, -81.8770],
            'puerto-armuelles' => [8.2500, -82.8500],
            'bugaba' => [8.4833, -82.6167],
            'boqueron' => [8.5000, -82.5667],
        ];

        foreach ($coordinates as $slug => [$lat, $lng]) {
            Zone::where('slug', $slug)->update(['lat' => $lat, 'lng' => $lng]);
        }
    }
}
