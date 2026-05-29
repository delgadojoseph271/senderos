<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class RouteResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'name' => $this->name,
            'slug' => $this->slug,
            'description' => $this->description,
            'difficulty' => $this->difficulty,
            'duration_minutes' => $this->duration_minutes,
            'distance_km' => (float) $this->distance_km,
            'elevation_gain_m' => $this->elevation_gain_m,
            'start_lat' => (float) $this->start_lat,
            'start_lng' => (float) $this->start_lng,
            'cover_image' => $this->cover_image,
            'tips' => $this->tips ?? [],
            'is_active' => $this->is_active,
            'zone' => new ZoneResource($this->whenLoaded('zone')),
            'category' => new CategoryResource($this->whenLoaded('category')),
            'images' => RouteImageResource::collection($this->whenLoaded('images')),
            'guides' => GuideResource::collection($this->whenLoaded('guides')),
            'created_at' => $this->created_at,
            'updated_at' => $this->updated_at,
        ];
    }
}
