import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/api/api_client.dart';

class GuideProfileScreen extends StatelessWidget {
  final int guideId;
  const GuideProfileScreen({super.key, required this.guideId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: ApiClient.instance.get('/guides/$guideId'),
      builder: (context, snap) {
        if (!snap.hasData) return const Scaffold(body: Center(child: CircularProgressIndicator()));
        final g = snap.data!.data;
        return Scaffold(
          appBar: AppBar(title: Text(g['name'])),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Center(
                child: CircleAvatar(
                  radius: 52,
                  backgroundImage: g['photo'] != null
                      ? CachedNetworkImageProvider(g['photo']) : null,
                  backgroundColor: Colors.grey.shade200,
                  child: g['photo'] == null ? const Icon(Icons.person, size: 44) : null,
                ),
              ),
              const SizedBox(height: 16),
              Center(child: Text(g['name'], style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold))),
              Center(child: Text(g['languages'] ?? 'Español', style: TextStyle(color: Colors.grey.shade600))),
              const SizedBox(height: 16),
              if (g['bio'] != null) ...[
                Text(g['bio'], style: const TextStyle(height: 1.6)),
                const SizedBox(height: 20),
              ],
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () => launchUrl(
                    Uri.parse('https://wa.me/${(g['whatsapp'] as String?)?.replaceAll('+', '') ?? ''}'),
                  ),
                  icon: const Icon(Icons.chat_outlined),
                  label: const Text('Contactar por WhatsApp'),
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF25D366),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ]),
          ),
        );
      },
    );
  }
}
