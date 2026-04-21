import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:veeras_beauty/core/theme.dart';
import 'package:veeras_beauty/features/auth/providers/auth_provider.dart';
import 'package:veeras_beauty/shared/widgets/gradient_button.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _obscurePassword = true;

  Future<void> _login() async {
    if (_emailCtrl.text.isEmpty || _passwordCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')));
      return;
    }
    await ref.read(authNotifierProvider.notifier).loginWithEmail(
      _emailCtrl.text.trim(), _passwordCtrl.text.trim(),
    );
    if (mounted) {
      final state = ref.read(authNotifierProvider);
      state.whenOrNull(
        error: (e, _) => ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()))),
        data: (_) => context.go('/'),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final isLoading = authState.isLoading;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 32),
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 80, height: 80,
                      decoration: const BoxDecoration(
                        gradient: AppTheme.primaryGradient,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(child: Text('💄', style: TextStyle(fontSize: 38))),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Veera's Beauty &",
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                    Text(
                      'Tattoo Studio',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              Text('Welcome Back', style: Theme.of(context).textTheme.displayMedium),
              const SizedBox(height: 4),
              Text('Sign in to your account', style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 28),

              TextField(
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email Address',
                  prefixIcon: Icon(Icons.email_outlined),
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: _passwordCtrl,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(_obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),
              ),
              const SizedBox(height: 28),

              GradientButton(
                label: isLoading ? 'Signing In...' : 'Sign In',
                icon: Icons.login,
                onPressed: isLoading ? null : _login,
              ),

              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account? ", style: Theme.of(context).textTheme.bodyMedium),
                  TextButton(
                    onPressed: () => context.pushReplacement('/register'),
                    child: const Text('Register'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Center(
                child: TextButton(
                  onPressed: () => context.go('/'),
                  child: const Text('Continue as Guest →'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
