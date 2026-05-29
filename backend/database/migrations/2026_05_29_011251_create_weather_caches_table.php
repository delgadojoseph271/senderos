<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('weather_cache', function (Blueprint $table) {
            $table->id();
            $table->foreignId('zone_id')->constrained()->cascadeOnDelete();
            $table->decimal('temp_c', 4, 1);
            $table->decimal('rain_mm', 5, 2)->default(0);
            $table->enum('risk_level', ['bajo', 'medio', 'alto']);
            $table->timestamp('fetched_at');
            $table->timestamps();

            $table->index('zone_id');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('weather_caches');
    }
};
