<?php

namespace App\Http\Controllers\Api;

use App\Events\BookingConfirmed;
use App\Http\Controllers\Controller;
use App\Http\Resources\BookingResource;
use App\Models\Booking;
use App\Models\Route;
use App\Models\RouteGuide;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class BookingController extends Controller
{
    public function index(Request $request): JsonResponse
    {
        $bookings = Booking::with(['route', 'guide'])
            ->where('user_id', $request->user()->id)
            ->orderByDesc('created_at')
            ->get();

        return response()->json(BookingResource::collection($bookings));
    }

    public function store(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'route_id' => 'required|exists:routes,id,is_active,1',
            'guide_id' => 'required|exists:guides,id',
            'date' => 'required|date|after:today',
            'pax' => 'required|integer|min:1|max:20',
            'notes' => 'nullable|string|max:500',
        ]);

        $pivotExists = RouteGuide::where('route_id', $validated['route_id'])
            ->where('guide_id', $validated['guide_id'])
            ->exists();

        if (!$pivotExists) {
            return response()->json([
                'message' => 'El guía no está asociado a esta ruta.',
            ], 422);
        }

        $total = $validated['pax'] * 30.00;

        $booking = Booking::create([
            'user_id' => $request->user()->id,
            'route_id' => $validated['route_id'],
            'guide_id' => $validated['guide_id'],
            'date' => $validated['date'],
            'pax' => $validated['pax'],
            'total_usd' => $total,
            'notes' => $validated['notes'],
            'status' => 'confirmed',
            'payment_status' => 'fake_paid',
        ]);

        $booking->load(['route', 'guide']);

        event(new BookingConfirmed($booking));

        return response()->json(new BookingResource($booking), 201);
    }

    public function show(Request $request, int $id): JsonResponse
    {
        $booking = Booking::with(['route', 'guide'])
            ->where('user_id', $request->user()->id)
            ->findOrFail($id);

        return response()->json(new BookingResource($booking));
    }

    public function destroy(Request $request, int $id): JsonResponse
    {
        $booking = Booking::where('user_id', $request->user()->id)->findOrFail($id);

        if ($booking->status === 'cancelled') {
            return response()->json(['message' => 'La reserva ya está cancelada.'], 400);
        }

        $booking->update(['status' => 'cancelled']);

        return response()->json(['message' => 'Reserva cancelada.']);
    }
}
