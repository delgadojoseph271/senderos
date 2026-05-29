<?php

namespace Database\Seeders;

use App\Models\Badge;
use Illuminate\Database\Seeder;

class BadgeSeeder extends Seeder
{
    public function run(): void
    {
        $badges = [
            [
                'name' => 'Primera aventura',
                'slug' => 'primera-aventura',
                'description' => 'Completaste tu primera reserva.',
                'icon' => '🥾',
                'condition_type' => 'bookings_count',
                'condition_value' => 1,
            ],
            [
                'name' => 'Explorador',
                'slug' => 'explorador',
                'description' => 'Completaste 5 reservas.',
                'icon' => '🗺️',
                'condition_type' => 'bookings_count',
                'condition_value' => 5,
            ],
            [
                'name' => 'Recorre Chiriquí',
                'slug' => 'recorre-chiriqui',
                'description' => 'Visitaste 3 zonas diferentes.',
                'icon' => '🏔️',
                'condition_type' => 'zones_visited',
                'condition_value' => 3,
            ],
            [
                'name' => 'Senderista',
                'slug' => 'senderista',
                'description' => 'Completaste 3 rutas de senderismo.',
                'icon' => '🌿',
                'condition_type' => 'category_count:senderismo',
                'condition_value' => 3,
            ],
            [
                'name' => 'Amante del café',
                'slug' => 'amante-cafe',
                'description' => 'Completaste 2 rutas de café.',
                'icon' => '☕',
                'condition_type' => 'category_count:cafe',
                'condition_value' => 2,
            ],
            [
                'name' => 'Coleccionista',
                'slug' => 'coleccionista',
                'description' => 'Visitaste 5 zonas diferentes.',
                'icon' => '🏆',
                'condition_type' => 'zones_visited',
                'condition_value' => 5,
            ],
        ];

        foreach ($badges as $badge) {
            Badge::create($badge);
        }
    }
}
