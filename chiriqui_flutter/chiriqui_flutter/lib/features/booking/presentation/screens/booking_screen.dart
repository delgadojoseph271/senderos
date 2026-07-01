import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../route_detail/providers/route_detail_provider.dart';
import '../../data/booking_repository.dart';
import '../../../../core/models/route_model.dart';

class BookingScreen extends ConsumerStatefulWidget {
  final String slug;
  const BookingScreen({super.key, required this.slug});

  @override
  ConsumerState<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends ConsumerState<BookingScreen> {
  int? _selectedGuideId;
  DateTime? _selectedDate;
  int _pax = 1;
  final _notesCtrl = TextEditingController();
  bool _loading = false;

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now().add(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _confirm(RouteModel route) async {
    if (_selectedGuideId == null || _selectedDate == null) return;
    setState(() => _loading = true);
    try {
      final booking = await BookingRepository().createBooking(
        routeId: route.id,
        guideId: _selectedGuideId!,
        date: '${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2,'0')}-${_selectedDate!.day.toString().padLeft(2,'0')}',
        pax: _pax,
        notes: _notesCtrl.text,
      );
      if (mounted) context.go('/routes/${widget.slug}/book/confirm?id=${booking.id}');
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al reservar: $e')),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(routeDetailProvider(widget.slug));

    return async.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(body: Center(child: Text('$e'))),
      data: (route) => Scaffold(
        appBar: AppBar(title: Text('Reservar — ${route.name}')),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

            // Guía
            const Text('Seleccioná un guía', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            ...route.guides.map((g) => RadioListTile<int>(
              value: g.id,
              groupValue: _selectedGuideId,
              onChanged: (v) => setState(() => _selectedGuideId = v),
              title: Text(g.name),
              subtitle: Text(g.languages, style: const TextStyle(fontSize: 12)),
              activeColor: const Color(0xFF1B5E20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: Colors.grey.shade200),
              ),
            )),

            const SizedBox(height: 20),

            // Fecha
            const Text('Fecha', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _pickDate,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(children: [
                  const Icon(Icons.calendar_today_outlined, size: 18, color: Colors.grey),
                  const SizedBox(width: 10),
                  Text(
                    _selectedDate == null
                        ? 'Seleccioná una fecha'
                        : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                    style: TextStyle(color: _selectedDate == null ? Colors.grey : Colors.black87),
                  ),
                ]),
              ),
            ),

            const SizedBox(height: 20),

            // Personas
            const Text('Personas', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Row(children: [
              IconButton(
                onPressed: _pax > 1 ? () => setState(() => _pax--) : null,
                icon: const Icon(Icons.remove_circle_outline),
              ),
              Text('$_pax', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              IconButton(
                onPressed: _pax < 20 ? () => setState(() => _pax++) : null,
                icon: const Icon(Icons.add_circle_outline),
              ),
            ]),

            const SizedBox(height: 20),

            // Notas
            TextField(
              controller: _notesCtrl,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Notas (opcional)',
                hintText: 'Ej: Somos principiantes, llevamos niños...',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 24),

            // Total
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF1B5E20).withOpacity(0.06),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('$_pax persona${_pax > 1 ? 's' : ''} × \$${AppConstants.pricePerPerson.toStringAsFixed(0)}'),
                Text(
                  '\$${(_pax * AppConstants.pricePerPerson).toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ]),
            ),
            const SizedBox(height: 6),
            Text('Pago simulado — no se realiza ningún cobro real.',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: (_selectedGuideId != null && _selectedDate != null && !_loading)
                    ? () => _confirm(route)
                    : null,
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF1B5E20),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: _loading
                    ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Text('Confirmar reserva', style: TextStyle(fontSize: 15)),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
