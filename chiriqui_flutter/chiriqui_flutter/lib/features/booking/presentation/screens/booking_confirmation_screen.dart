import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BookingConfirmationScreen extends StatelessWidget {
  final int bookingId;
  const BookingConfirmationScreen({super.key, required this.bookingId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(
              width: 80, height: 80,
              decoration: const BoxDecoration(
                color: Color(0xFF1B5E20),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, color: Colors.white, size: 44),
            ),
            const SizedBox(height: 24),
            const Text('¡Reserva confirmada!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Número de reserva: #$bookingId',
                style: TextStyle(color: Colors.grey.shade600)),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => context.go('/bookings'),
                style: FilledButton.styleFrom(backgroundColor: const Color(0xFF1B5E20)),
                child: const Text('Ver mis reservas'),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => context.go('/'),
                child: const Text('Volver al inicio'),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
