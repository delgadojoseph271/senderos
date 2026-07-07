<?php

namespace Database\Seeders;

use App\Models\RouteImage;
use Illuminate\Database\Seeder;

class RouteImageSeeder extends Seeder
{
    public function run(): void
    {
        $images = [
            // Sendero Los Quetzales
            ['route_id' => 1, 'image_url' => 'https://placehold.co/800x600/2563eb/ffffff.png?text=Quetzales+1', 'sort_order' => 0],
            ['route_id' => 1, 'image_url' => 'https://placehold.co/800x600/3b82f6/ffffff.png?text=Quetzales+2', 'sort_order' => 1],
            ['route_id' => 1, 'image_url' => 'https://placehold.co/800x600/60a5fa/ffffff.png?text=Quetzales+3', 'sort_order' => 2],
            // Volcán Barú
            ['route_id' => 2, 'image_url' => 'https://placehold.co/800x600/16a34a/ffffff.png?text=Baru+1', 'sort_order' => 0],
            ['route_id' => 2, 'image_url' => 'https://placehold.co/800x600/22c55e/ffffff.png?text=Baru+2', 'sort_order' => 1],
            // Cascada Escondida
            ['route_id' => 3, 'image_url' => 'https://placehold.co/800x600/0284c7/ffffff.png?text=Cascada+1', 'sort_order' => 0],
            ['route_id' => 3, 'image_url' => 'https://placehold.co/800x600/38bdf8/ffffff.png?text=Cascada+2', 'sort_order' => 1],
            ['route_id' => 3, 'image_url' => 'https://placehold.co/800x600/7dd3fc/ffffff.png?text=Cascada+3', 'sort_order' => 2],
            // Termales de Caldera
            ['route_id' => 4, 'image_url' => 'https://placehold.co/800x600/d97706/ffffff.png?text=Termales+1', 'sort_order' => 0],
            ['route_id' => 4, 'image_url' => 'https://placehold.co/800x600/f59e0b/ffffff.png?text=Termales+2', 'sort_order' => 1],
            // Ruta del Café
            ['route_id' => 5, 'image_url' => 'https://placehold.co/800x600/92400e/ffffff.png?text=Cafe+1', 'sort_order' => 0],
            ['route_id' => 5, 'image_url' => 'https://placehold.co/800x600/a16207/ffffff.png?text=Cafe+2', 'sort_order' => 1],
            // Rafting
            ['route_id' => 6, 'image_url' => 'https://placehold.co/800x600/0d9488/ffffff.png?text=Rafting+1', 'sort_order' => 0],
            // Playa Las Lajas
            ['route_id' => 7, 'image_url' => 'https://placehold.co/800x600/0ea5e9/ffffff.png?text=Lajas+1', 'sort_order' => 0],
            ['route_id' => 7, 'image_url' => 'https://placehold.co/800x600/38bdf8/ffffff.png?text=Lajas+2', 'sort_order' => 1],
            ['route_id' => 7, 'image_url' => 'https://placehold.co/800x600/7dd3fc/ffffff.png?text=Lajas+3', 'sort_order' => 2],
            // Boca Chica
            ['route_id' => 8, 'image_url' => 'https://placehold.co/800x600/0891b2/ffffff.png?text=Boca+1', 'sort_order' => 0],
            ['route_id' => 8, 'image_url' => 'https://placehold.co/800x600/22d3ee/ffffff.png?text=Boca+2', 'sort_order' => 1],
            // Cerro Punta
            ['route_id' => 9, 'image_url' => 'https://placehold.co/800x600/65a30d/ffffff.png?text=Punta+1', 'sort_order' => 0],
            ['route_id' => 9, 'image_url' => 'https://placehold.co/800x600/84cc16/ffffff.png?text=Punta+2', 'sort_order' => 1],
            // Cascada Los Chorros
            ['route_id' => 10, 'image_url' => 'https://placehold.co/800x600/0f766e/ffffff.png?text=Chorros+1', 'sort_order' => 0],
            ['route_id' => 10, 'image_url' => 'https://placehold.co/800x600/14b8a6/ffffff.png?text=Chorros+2', 'sort_order' => 1],
        ];

        foreach ($images as $image) {
            RouteImage::create($image);
        }
    }
}
