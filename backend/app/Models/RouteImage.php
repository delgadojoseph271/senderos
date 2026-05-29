<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class RouteImage extends Model
{
    protected $fillable = ['route_id', 'image_url', 'sort_order'];

    public function route()
    {
        return $this->belongsTo(Route::class);
    }
}
