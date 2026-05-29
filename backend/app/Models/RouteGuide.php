<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class RouteGuide extends Model
{
    protected $fillable = ['route_id', 'guide_id'];

    public function route()
    {
        return $this->belongsTo(Route::class);
    }

    public function guide()
    {
        return $this->belongsTo(Guide::class);
    }
}
