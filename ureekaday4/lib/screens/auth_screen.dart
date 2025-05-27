import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();

  String? error;
  bool loading = false;

  bool isLogin = true; // mode login/register

  void _submit() async {
    setState(() {
      loading = true;
      error = null;
    });

    String? err;
    if (isLogin) {
      err = await _authService.login(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
    } else {
      err = await _authService.register(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
    }

    setState(() {
      loading = false;
      error = err;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isLogin ? 'Login' : 'Register')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            if (error != null)
              Text(error!, style: const TextStyle(color: Colors.red)),
            loading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _submit,
                    child: Text(isLogin ? 'Login' : 'Register'),
                  ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                setState(() {
                  isLogin = !isLogin;
                  error = null;
                });
              },
              child: Text(
                isLogin ? 'Belum punya akun? Daftar' : 'Sudah punya akun? Login',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
