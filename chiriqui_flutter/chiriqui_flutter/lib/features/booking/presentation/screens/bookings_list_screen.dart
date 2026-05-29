import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../data/booking_repository.dart';
import '../../../../core/models/booking_model.dart';

final _bookingsProvider = FutureProvider.autoDispose((_) => BookingRepository().getBookings());

class BookingsListScreen extends ConsumerWidget {
  const BookingsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(_bookingsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Mis reservas')),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (bookings) => bookings.isEmpty
            ? Center(
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  const Icon(Icons.calendar_today_outlined, size: 52, color: Colors.grey),
                  const SizedBox(height: 12),
                  const Text('Todavía no tenés reservas.', style: TextStyle(color: Colors.grey)),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () => context.go('/'),
                    style: FilledButton.styleFrom(backgroundColor: const Color(0xFF1B5E20)),
                    child: const Text('Explorar rutas'),
                  ),
                ]),
              )
            : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: bookings.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (_, i) => _BookingCard(
                  booking: bookings[i],
                  onCancel: () async {
                    await BookingRepository().cancelBooking(bookings[i].id);
                    ref.invalidate(_bookingsProvider);
                  },
                ),
              ),
      ),
    );
  }
}

class _BookingCard extends StatelessWidget {
  final BookingModel booking;
  final VoidCallback onCancel;
  const _BookingCard({required this.booking, required this.onCancel});

  Color _statusColor(String s) {
    switch (s) {
      case 'confirmed': return const Color(0xFF43A047);
      case 'cancelled': return const Color(0xFFE53935);
      default:          return Colors.grey;
    }
  }

  String _statusLabel(String s) {
    switch (s) {
      case 'confirmed': return 'Confirmada';
      case 'cancelled': return 'Cancelada';
      default:          return s;
    }
  }

  bool get _isFuture => DateTime.parse(booking.date).isAfter(DateTime.now());

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Expanded(
              child: Text(booking.route.name,
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: _statusColor(booking.status).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(_statusLabel(booking.status),
                  style: TextStyle(color: _statusColor(booking.status), fontSize: 12, fontWeight: FontWeight.w500)),
            ),
          ]),
          const SizedBox(height: 6),
          Text('Guía: ${booking.guide.name}', style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
          Text('Fecha: ${booking.date}  ·  ${booking.pax} persona${booking.pax > 1 ? 's' : ''}',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
          Text('Total: \$${booking.totalUsd.toStringAsFixed(2)}',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
          if (booking.status == 'confirmed' && _isFuture) ...[
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('Cancelar reserva'),
                    content: const Text('¿Estás seguro? Esta acción no se puede deshacer.'),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(context), child: const Text('No')),
                      FilledButton(
                        onPressed: () { Navigator.pop(context); onCancel(); },
                        style: FilledButton.styleFrom(backgroundColor: Colors.red),
                        child: const Text('Cancelar reserva'),
                      ),
                    ],
                  ),
                ),
                child: const Text('Cancelar', style: TextStyle(color: Colors.red)),
              ),
            ),
          ],
        ]),
      ),
    );
  }
}
