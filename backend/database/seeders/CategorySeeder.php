<?php

namespace Database\Seeders;

use App\Models\Category;
use Illuminate\Database\Seeder;

class CategorySeeder extends Seeder
{
    public function run(): void
    {
        $categories = [
            ['name' => 'Senderismo', 'slug' => 'senderismo', 'description' => 'Rutas de trekking y caminatas por montañas, bosques y volcanes.'],
            ['name' => 'Café', 'slug' => 'cafe', 'description' => 'Recorridos por fincas cafetaleras con degustación del mejor café de altura.'],
            ['name' => 'Cascadas', 'slug' => 'cascadas', 'description' => 'Rutas que llevan a impresionantes saltos de agua y pozas naturales.'],
            ['name' => 'Playas', 'slug' => 'playas', 'description' => 'Destinos de costa pacífica con arena, mar y actividades playeras.'],
            ['name' => 'Termales', 'slug' => 'termales', 'description' => 'Aguas termales naturales ricas en minerales rodeadas de naturaleza.'],
            ['name' => 'Aventura', 'slug' => 'aventura', 'description' => 'Rafting, tirolesa, canopy y actividades de adrenalina en la naturaleza.'],
            ['name' => 'Cultura', 'slug' => 'cultura', 'description' => 'Recorridos históricos, museos, artesanía y tradiciones locales.'],
            ['name' => 'Gastronomía', 'slug' => 'gastronomia', 'description' => 'Rutas culinarias con platos típicos, frutas exóticas y cocina tradicional.'],
            ['name' => 'Avistamiento de Aves', 'slug' => 'avistamiento-de-aves', 'description' => 'Observación de aves residentes y migratorias en hábitats diversos.'],
            ['name' => 'Miradores', 'slug' => 'miradores', 'description' => 'Puntos panorámicos con vistas espectaculares del valle, mar y montañas.'],
        ];

        foreach ($categories as $category) {
            Category::create($category);
        }
    }
}
