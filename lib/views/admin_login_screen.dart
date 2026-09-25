import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/auth_viewmodel.dart';

// Admin Login Screen
class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  // Form State Section
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _hidePassword = true;
  // Form State End

  // Login Action Section
  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    FocusScope.of(context).unfocus();

    final success = await context.read<AuthViewModel>().login(
          _emailController.text,
          _passwordController.text,
        );

    if (!mounted) return;

    if (success) {
      _passwordController.clear();
    }
  }
  // Login Action End

  // Controllers Cleanup Section
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
  // Controllers Cleanup End

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xffedf3fc),

      // App Bar Section
      appBar: AppBar(
        title: const Text('Admin Login'),
      ),
      // App Bar End

      // Login Card Section
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Container(
              width: 440,
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: const Color(0xffedf3fc),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: Colors.white70),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.white,
                    offset: Offset(-6, -6),
                    blurRadius: 16,
                  ),
                  BoxShadow(
                    color: Color(0xffc4d1e3),
                    offset: Offset(6, 6),
                    blurRadius: 16,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header Section
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        'assets/images/app_icon.png',
                        width: 80,
                        height: 80,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    auth.isAdmin ? 'Welcome, Faraz!' : 'Welcome Back',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff142158),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    auth.isAdmin
                        ? 'You are signed in as the admin.'
                        : 'Sign in to manage your portfolio.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xff52647e),
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 28),
                  // Header End

                  // Login Form Section
                  if (!auth.isAdmin)
                    Form(
                      key: _formKey,
                      child: AutofillGroup(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Email Section
                            TextFormField(
                              controller: _emailController,
                              enabled: !auth.isLoading,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              autofillHints: const [AutofillHints.email],
                              autocorrect: false,
                              decoration: _decoration(
                                'Email',
                                Icons.email_outlined,
                              ),
                              validator: (value) {
                                final email = value?.trim() ?? '';

                                if (email.isEmpty || !email.contains('@')) {
                                  return 'Enter a valid email.';
                                }

                                return null;
                              },
                            ),
                            // Email End

                            const SizedBox(height: 20),

                            // Password Section
                            TextFormField(
                              controller: _passwordController,
                              enabled: !auth.isLoading,
                              obscureText: _hidePassword,
                              autocorrect: false,
                              enableSuggestions: false,
                              autofillHints: const [AutofillHints.password],
                              textInputAction: TextInputAction.done,
                              onFieldSubmitted: (_) {
                                if (!auth.isLoading) _login();
                              },
                              decoration: _decoration(
                                'Password',
                                Icons.lock_outline,
                              ).copyWith(
                                suffixIcon: IconButton(
                                  tooltip: _hidePassword
                                      ? 'Show password'
                                      : 'Hide password',
                                  onPressed: () {
                                    setState(() {
                                      _hidePassword = !_hidePassword;
                                    });
                                  },
                                  icon: Icon(
                                    _hidePassword
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Enter your password.';
                                }

                                return null;
                              },
                            ),
                            // Password End

                            const SizedBox(height: 24),

                            // Login Button Section
                            FilledButton(
                              onPressed: auth.isLoading ? null : _login,
                              style: FilledButton.styleFrom(
                                backgroundColor: const Color(0xff036ffc),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              child: auth.isLoading
                                  ? const SizedBox(
                                      width: 22,
                                      height: 22,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Text('Login'),
                            ),
                            // Login Button End
                          ],
                        ),
                      ),
                    ),
                  // Login Form End

                  // Logged In Section
                  if (auth.isAdmin) ...[
                    const Icon(
                      Icons.verified_user_outlined,
                      size: 56,
                      color: Color(0xff036ffc),
                    ),
                    const SizedBox(height: 20),
                    OutlinedButton(
                      onPressed: auth.isLoading
                          ? null
                          : () async {
                              await context.read<AuthViewModel>().logout();
                            },
                      child: Text(
                        auth.isLoading ? 'Signing out...' : 'Logout',
                      ),
                    ),
                  ],
                  // Logged In End

                  // Error Section
                  if (auth.error != null) ...[
                    const SizedBox(height: 16),
                    Text(
                      auth.error!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ],
                  // Error End
                ],
              ),
            ),
          ),
        ),
      ),
      // Login Card End
    );
  }

  // Input Style Section
  InputDecoration _decoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      filled: true,
      fillColor: Colors.white70,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
      ),
    );
  }
  // Input Style End
}
// Admin Login Screen End