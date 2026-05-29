import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/auth/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameCtrl  = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl  = TextEditingController();
  final _confCtrl  = TextEditingController();
  bool _loading = false;
  String? _error;

  Future<void> _register() async {
    if (_passCtrl.text != _confCtrl.text) {
      setState(() => _error = 'Las contraseñas no coinciden.');
      return;
    }
    if (_passCtrl.text.length < 8) {
      setState(() => _error = 'La contraseña debe tener al menos 8 caracteres.');
      return;
    }
    setState(() { _loading = true; _error = null; });
    try {
      await AuthService().register(_nameCtrl.text.trim(), _emailCtrl.text.trim(), _passCtrl.text);
      if (mounted) context.go('/');
    } catch (e) {
      setState(() => _error = 'No se pudo crear la cuenta. Verificá que el email no esté en uso.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crear cuenta')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SizedBox(height: 20),
          const Text('Nueva cuenta', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
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

          TextField(controller: _nameCtrl, decoration: const InputDecoration(labelText: 'Nombre', border: OutlineInputBorder())),
          const SizedBox(height: 16),
          TextField(controller: _emailCtrl, keyboardType: TextInputType.emailAddress, decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder())),
          const SizedBox(height: 16),
          TextField(controller: _passCtrl, obscureText: true, decoration: const InputDecoration(labelText: 'Contraseña', border: OutlineInputBorder())),
          const SizedBox(height: 16),
          TextField(controller: _confCtrl, obscureText: true, decoration: const InputDecoration(labelText: 'Confirmar contraseña', border: OutlineInputBorder())),
          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _loading ? null : _register,
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF1B5E20),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: _loading
                  ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Text('Crear cuenta', style: TextStyle(fontSize: 15)),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: TextButton(
              onPressed: () => context.pop(),
              child: const Text('¿Ya tenés cuenta? Iniciá sesión'),
            ),
          ),
        ]),
      ),
    );
  }
}
