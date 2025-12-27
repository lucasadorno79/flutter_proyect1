import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final userCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  bool error = false;

  Future<void> login() async {
    final ok = await AuthService.login(
      userCtrl.text,
      passCtrl.text,
    );

    if (ok && mounted) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      setState(() => error = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.pets, size: 80),
            const SizedBox(height: 16),
            const Text(
              'Catmanager',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 24),

            TextField(
              controller: userCtrl,
              decoration: const InputDecoration(labelText: 'Usuario'),
            ),
            TextField(
              controller: passCtrl,
              decoration: const InputDecoration(
                labelText: 'Contraseña',
              ),
              obscureText: true,
            ),

            if (error)
              const Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text(
                  'Credenciales inválidas',
                  style: TextStyle(color: Colors.red),
                ),
              ),

            const SizedBox(height: 16),

            ElevatedButton(
              onPressed: login,
              child: const Text('Ingresar'),
            ),
          ],
        ),
      ),
    );
  }
}
