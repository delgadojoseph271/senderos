<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Route extends Model
{
    protected $fillable = [
        'zone_id', 'category_id', 'name', 'slug', 'description',
        'difficulty', 'duration_minutes', 'distance_km', 'elevation_gain_m',
        'start_lat', 'start_lng', 'cover_image', 'tips', 'is_active',
    ];

    protected function casts(): array
    {
        return [
            'tips' => 'array',
            'is_active' => 'boolean',
        ];
    }

    public function zone()
    {
        return $this->belongsTo(Zone::class);
    }

    public function category()
    {
        return $this->belongsTo(Category::class);
    }

    public function images()
    {
        return $this->hasMany(RouteImage::class);
    }

    public function guides()
    {
        return $this->belongsToMany(Guide::class, 'route_guides');
    }
}
