import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/weather_provider.dart';

class WeatherWidget extends ConsumerWidget {
  final String zoneSlug;
  const WeatherWidget({super.key, required this.zoneSlug});

  Color _riskColor(String risk) {
    switch (risk) {
      case 'bajo':  return const Color(0xFF43A047);
      case 'medio': return const Color(0xFFFDD835);
      case 'alto':  return const Color(0xFFE53935);
      default:      return Colors.grey;
    }
  }

  IconData _riskIcon(String risk) {
    switch (risk) {
      case 'bajo':  return Icons.wb_sunny_outlined;
      case 'medio': return Icons.cloud_outlined;
      case 'alto':  return Icons.thunderstorm_outlined;
      default:      return Icons.help_outline;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(weatherProvider(zoneSlug));

    return async.when(
      loading: () => const SizedBox(
        height: 56,
        child: Center(child: LinearProgressIndicator()),
      ),
      error: (_, __) => const SizedBox.shrink(),
      data: (w) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: _riskColor(w.riskLevel).withOpacity(0.1),
          border: Border.all(color: _riskColor(w.riskLevel).withOpacity(0.4)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(children: [
          Icon(_riskIcon(w.riskLevel), color: _riskColor(w.riskLevel), size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('${w.tempC.toStringAsFixed(0)}°C  ·  ${w.rainMm.toStringAsFixed(1)} mm lluvia',
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
              Text('Riesgo: ${w.riskLevel}${w.stale ? "  · Datos desactualizados" : ""}',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
            ]),
          ),
        ]),
      ),
    );
  }
}
