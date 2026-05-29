<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Guide extends Model
{
    protected $fillable = ['name', 'phone', 'whatsapp', 'bio', 'photo'];

    public function routes()
    {
        return $this->belongsToMany(Route::class, 'route_guides');
    }
}
