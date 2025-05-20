import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

class LoginAccountScreen extends StatefulWidget {
  const LoginAccountScreen({super.key});

  @override
  State<LoginAccountScreen> createState() => _LoginAccountScreenState();
}

class _LoginAccountScreenState extends State<LoginAccountScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _signIn() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      if (mounted) context.go('/home');
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = e.message;
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Đăng nhập')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
    const SizedBox(height: 30),
    TextFormField(
      controller: _emailController,
      decoration: const InputDecoration(
        labelText: 'Email',
        border: OutlineInputBorder(),
      ),
      keyboardType: TextInputType.emailAddress,
      validator: (value) =>
          value!.isEmpty ? 'Vui lòng nhập email' : null,
    ),
    const SizedBox(height: 20),
    TextFormField(
      controller: _passwordController,
      obscureText: true,
      decoration: const InputDecoration(
        labelText: 'Mật khẩu',
        border: OutlineInputBorder(),
      ),
      validator: (value) =>
          value!.isEmpty ? 'Vui lòng nhập mật khẩu' : null,
    ),
    const SizedBox(height: 20),
    if (_errorMessage != null)
      Text(
        _errorMessage!,
        style: const TextStyle(color: Colors.red),
      ),
    const SizedBox(height: 20),
    ElevatedButton(
      onPressed: _isLoading
          ? null
          : () {
              if (_formKey.currentState!.validate()) {
                _signIn();
              }
            },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.orange,
        minimumSize: const Size(double.infinity, 50),
      ),
      child: _isLoading
          ? const CircularProgressIndicator(color: Colors.white)
          : const Text('Đăng nhập',
              style: TextStyle(fontSize: 16)),
    ),
    TextButton(
      onPressed: () {
        context.push('/register');
      },
      child: const Text(
        'Chưa có tài khoản? Đăng ký',
        style: TextStyle(color: Colors.blue),
      ),
    ),
  ],
          ),
        ),
      ),
    );
  }
}
