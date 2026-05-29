<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class WeatherCache extends Model
{
    protected $table = 'weather_cache';

    protected $fillable = ['zone_id', 'temp_c', 'rain_mm', 'risk_level', 'fetched_at'];

    protected function casts(): array
    {
        return [
            'fetched_at' => 'datetime',
        ];
    }

    public function zone()
    {
        return $this->belongsTo(Zone::class);
    }
}
