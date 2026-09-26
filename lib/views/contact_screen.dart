import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/contact_model.dart';
import '../viewmodels/contact_viewmodel.dart';

// Contact Provider Section

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ContactViewModel(),
      child: const _ContactForm(),
    );
  }
}

// Contact Provider End

// Contact Form Section

class _ContactForm extends StatefulWidget {
  const _ContactForm();

  @override
  State<_ContactForm> createState() => _ContactFormState();
}

class _ContactFormState extends State<_ContactForm> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _message = TextEditingController();

  // Submit Section

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    FocusScope.of(context).unfocus();

    final sent = await context.read<ContactViewModel>().sendMessage(
          ContactModel(
            name: _name.text,
            email: _email.text,
            message: _message.text,
          ),
        );

    if (!mounted || !sent) return;

    _formKey.currentState!.reset();
    _name.clear();
    _email.clear();
    _message.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Your message has been sent. Thank you!'),
      ),
    );
  }

  // Submit End

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _message.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ContactViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('Contact Me')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),

              // Contact Card Section
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xffedf3fc),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.white),
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
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Heading Section
                      const Icon(
                        Icons.mark_email_unread_outlined,
                        size: 48,
                        color: Color(0xff036ffc),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "Let's Work Together",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff142158),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Have a project or question? Send me a message.',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 28),
                      // Heading End

                      // Name Section
                      TextFormField(
                        controller: _name,
                        enabled: !viewModel.isSending,
                        maxLength: 80,
                        textCapitalization: TextCapitalization.words,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          labelText: 'Your name',
                          prefixIcon: Icon(Icons.person_outline),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if ((value ?? '').trim().length < 2) {
                            return 'Enter at least 2 characters.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      // Name End

                      // Email Section
                      TextFormField(
                        controller: _email,
                        enabled: !viewModel.isSending,
                        maxLength: 254,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        autocorrect: false,
                        decoration: const InputDecoration(
                          labelText: 'Your email',
                          prefixIcon: Icon(Icons.email_outlined),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          final email = (value ?? '').trim();
                          final valid = RegExp(
                            r'^[^\s@]+@[^\s@]+\.[^\s@]+$',
                          ).hasMatch(email);

                          return valid ? null : 'Enter a valid email.';
                        },
                      ),
                      const SizedBox(height: 16),
                      // Email End

                      // Message Section
                      TextFormField(
                        controller: _message,
                        enabled: !viewModel.isSending,
                        maxLength: 2000,
                        minLines: 4,
                        maxLines: 8,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: const InputDecoration(
                          labelText: 'Your message',
                          alignLabelWithHint: true,
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if ((value ?? '').trim().length < 10) {
                            return 'Enter at least 10 characters.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      // Message End

                      // Send Button Section
                      if (viewModel.error != null) ...[
                        Text(
                          viewModel.error!,
                          style: const TextStyle(color: Colors.red),
                        ),
                        const SizedBox(height: 12),
                      ],
                      FilledButton.icon(
                        onPressed: viewModel.isSending ? null : _submit,
                        icon: viewModel.isSending
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.send_outlined),
                        label: Text(
                          viewModel.isSending ? 'Sending...' : 'Send Message',
                        ),
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 18),
                        ),
                      ),
                      // Send Button End
                    ],
                  ),
                ),
              ),
              // Contact Card End
            ),
          ),
        ),
      ),
    );
  }
}

// Contact Form End