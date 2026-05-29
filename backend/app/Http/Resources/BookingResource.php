<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class BookingResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'status' => $this->status,
            'payment_status' => $this->payment_status,
            'date' => $this->date->format('Y-m-d'),
            'pax' => $this->pax,
            'total_usd' => (float) $this->total_usd,
            'notes' => $this->notes,
            'route' => [
                'id' => $this->whenHas('route_id'),
                'name' => $this->whenLoaded('route', fn() => $this->route->name),
                'slug' => $this->whenLoaded('route', fn() => $this->route->slug),
            ],
            'guide' => [
                'id' => $this->whenHas('guide_id'),
                'name' => $this->whenLoaded('guide', fn() => $this->guide->name),
            ],
            'created_at' => $this->created_at,
        ];
    }
}
