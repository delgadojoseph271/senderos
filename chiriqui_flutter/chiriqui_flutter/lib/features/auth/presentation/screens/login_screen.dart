import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/auth/auth_service.dart';

class LoginScreen extends ConsumerStatefulWidget {
  final String? redirect;
  const LoginScreen({super.key, this.redirect});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passCtrl  = TextEditingController();
  bool _loading = false;
  String? _error;

  Future<void> _login() async {
    setState(() { _loading = true; _error = null; });
    try {
      await AuthService().login(_emailCtrl.text.trim(), _passCtrl.text);
      if (mounted) context.go(widget.redirect ?? '/');
    } catch (e) {
      setState(() => _error = 'Credenciales incorrectas. Verificá tu email y contraseña.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Iniciar sesión')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SizedBox(height: 20),
          const Text('Bienvenido', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text('Ingresá para reservar rutas y ver tus badges.',
              style: TextStyle(color: Colors.grey.shade600)),
          const SizedBox(height: 32),

          if (_error != null) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: Text(_error!, style: TextStyle(color: Colors.red.shade700, fontSize: 13)),
            ),
            const SizedBox(height: 16),
          ],

          TextField(
            controller: _emailCtrl,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _passCtrl,
            obscureText: true,
            decoration: const InputDecoration(labelText: 'Contraseña', border: OutlineInputBorder()),
            onSubmitted: (_) => _login(),
          ),
          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _loading ? null : _login,
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF1B5E20),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: _loading
                  ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Text('Iniciar sesión', style: TextStyle(fontSize: 15)),
            ),
          ),
          const SizedBox(height: 16),

          Center(
            child: TextButton(
              onPressed: () => context.push('/auth/register'),
              child: const Text('¿No tenés cuenta? Registrate'),
            ),
          ),
        ]),
      ),
    );
  }
}
