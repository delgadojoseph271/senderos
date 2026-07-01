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
                'id' => $this->route_id,
                'name' => $this->route?->name ?? '',
                'slug' => $this->route?->slug ?? '',
            ],
            'guide' => [
                'id' => $this->guide_id,
                'name' => $this->guide?->name ?? '',
            ],
            'created_at' => $this->created_at,
        ];
    }
}
