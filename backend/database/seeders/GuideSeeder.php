<?php

namespace Database\Seeders;

use App\Models\Guide;
use Illuminate\Database\Seeder;

class GuideSeeder extends Seeder
{
    public function run(): void
    {
        $guides = [
            [
                'name' => 'Carlos Mendoza',
                'phone' => '+507 6000-1111',
                'whatsapp' => '+50760001111',
                'bio' => 'Guía certificado con 10 años de experiencia en el Sendero Los Quetzales y Volcán Barú. Especialista en avistamiento de aves y fotografía de naturaleza.',
                'photo' => 'https://placehold.co/400x400/2563eb/ffffff?text=CM',
            ],
            [
                'name' => 'María Castillo',
                'phone' => '+507 6000-2222',
                'whatsapp' => '+50760002222',
                'bio' => 'Guía local de Cerro Punta con amplio conocimiento de la flora y fauna de Tierras Altas. Tours educativos sobre agricultura sostenible.',
                'photo' => 'https://placehold.co/400x400/16a34a/ffffff?text=MC',
            ],
            [
                'name' => 'Roberto Quintero',
                'phone' => '+507 6000-3333',
                'whatsapp' => '+50760003333',
                'bio' => 'Instructor de rafting certificado por la Asociación Panameña de Rafting. Más de 500 descensos por el río Chiriquí.',
                'photo' => 'https://placehold.co/400x400/0d9488/ffffff?text=RQ',
            ],
            [
                'name' => 'Ana Jiménez',
                'phone' => '+507 6000-4444',
                'whatsapp' => '+50760004444',
                'bio' => 'Guía turística bilingüe especializada en la Ruta del Café de Boquete. Experta en catación y procesos de café de especialidad.',
                'photo' => 'https://placehold.co/400x400/92400e/ffffff?text=AJ',
            ],
            [
                'name' => 'Luis Gómez',
                'phone' => '+507 6000-5555',
                'whatsapp' => '+50760005555',
                'bio' => 'Pescador local y guía de paseos en lancha por el archipiélago de Boca Chica. Conoce cada isla y sus mejores spots de snorkel.',
                'photo' => 'https://placehold.co/400x400/0891b2/ffffff?text=LG',
            ],
            [
                'name' => 'Elena Rodríguez',
                'phone' => '+507 6000-6666',
                'whatsapp' => '+50760006666',
                'bio' => 'Guía de naturaleza con enfoque en ecoturismo. Recorre las cascadas y senderos de Gualaca promoviendo el turismo responsable.',
                'photo' => 'https://placehold.co/400x400/0f766e/ffffff?text=ER',
            ],
        ];

        foreach ($guides as $guide) {
            Guide::create($guide);
        }
    }
}
