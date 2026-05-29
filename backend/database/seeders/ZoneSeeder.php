<?php

namespace Database\Seeders;

use App\Models\Zone;
use Illuminate\Database\Seeder;

class ZoneSeeder extends Seeder
{
    public function run(): void
    {
        $zones = [
            ['name' => 'Boquete', 'slug' => 'boquete', 'description' => 'Valle de la Eterna Primavera, famoso por su café, senderismo y clima de montaña.'],
            ['name' => 'Volcán', 'slug' => 'volcan', 'description' => 'Zona alta dominada por el Volcán Barú, con paisajes agrícolas y rutas de montaña.'],
            ['name' => 'David', 'slug' => 'david', 'description' => 'Capital de la provincia de Chiriquí, centro urbano y comercial.'],
            ['name' => 'Gualaca', 'slug' => 'gualaca', 'description' => 'Destino de aventura con rafting, termales y cascadas en la cuenca del río Chiriquí.'],
            ['name' => 'Tierras Altas', 'slug' => 'tierras-altas', 'description' => 'Cerro Punta y alrededores, zona agrícola de altura con paisajes espectaculares.'],
            ['name' => 'San Lorenzo', 'slug' => 'san-lorenzo', 'description' => 'Distrito costero con extensas playas de arena oscura.'],
            ['name' => 'Boca Chica', 'slug' => 'boca-chica', 'description' => 'Pueblo pesquero con playas vírgenes, islas y deportes acuáticos.'],
            ['name' => 'Puerto Armuelles', 'slug' => 'puerto-armuelles', 'description' => 'Puerto bananero en el Pacífico, con playas y oleaje para surf.'],
            ['name' => 'Bugaba', 'slug' => 'bugaba', 'description' => 'Distrito agrícola con la ciudad de La Concepción como cabecera.'],
            ['name' => 'Boquerón', 'slug' => 'boqueron', 'description' => 'Zona de transición entre montaña y costa, conocida por sus mangos.'],
        ];

        foreach ($zones as $zone) {
            Zone::create($zone);
        }
    }
}
