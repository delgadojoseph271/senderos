<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Zone extends Model
{
    protected $fillable = ['name', 'slug', 'description', 'lat', 'lng'];

    public function routes()
    {
        return $this->hasMany(Route::class);
    }
}
