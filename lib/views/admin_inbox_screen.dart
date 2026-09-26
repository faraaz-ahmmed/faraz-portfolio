import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/contact_model.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../viewmodels/inbox_viewmodel.dart';

// Admin Access Section

class AdminInboxScreen extends StatelessWidget {
  const AdminInboxScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isAdmin = context.watch<AuthViewModel>().isAdmin;

    if (!isAdmin) {
      return Scaffold(
        appBar: AppBar(title: const Text('Admin Inbox')),
        body: const Center(
          child: Text('Please sign in as admin to view messages.'),
        ),
      );
    }

    return ChangeNotifierProvider(
      create: (_) => InboxViewModel(),
      child: const _InboxContent(),
    );
  }
}

// Admin Access End

// Inbox Content Section

class _InboxContent extends StatelessWidget {
  const _InboxContent();

  // Delete Confirmation Section

  Future<void> _deleteMessage(
    BuildContext context,
    ContactModel message,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete message?'),
        content: Text(
          'The message from ${message.name} will be permanently deleted.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (!context.mounted || confirmed != true) return;
    if (!context.read<AuthViewModel>().isAdmin) return;

    final viewModel = context.read<InboxViewModel>();
    final deleted = await viewModel.deleteMessage(message.id);

    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          deleted
              ? 'Message deleted.'
              : viewModel.actionError ?? 'Unable to delete message.',
        ),
      ),
    );
  }

  // Delete Confirmation End

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<InboxViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('Admin Inbox')),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 850),
            child: _buildMessages(context, viewModel),
          ),
        ),
      ),
    );
  }

  // Messages List Section

  Widget _buildMessages(
    BuildContext context,
    InboxViewModel viewModel,
  ) {
    if (viewModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (viewModel.loadError != null) {
      return Center(child: Text(viewModel.loadError!));
    }

    if (viewModel.messages.isEmpty) {
      return const Center(child: Text('No messages yet.'));
    }

    return ListView.separated(
      padding: const EdgeInsets.all(24),
      itemCount: viewModel.messages.length,
      separatorBuilder: (_, __) => const SizedBox(height: 20),
      itemBuilder: (context, index) {
        final message = viewModel.messages[index];
        final date = message.createdAt?.toLocal();

        // Message Card Section
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xffedf3fc),
            borderRadius: BorderRadius.circular(20),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: Color(0xff036ffc),
                    child: Icon(
                      Icons.person_outline,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      message.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff142158),
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Delete message',
                    onPressed: viewModel.isDeleting
                        ? null
                        : () => _deleteMessage(context, message),
                    icon: const Icon(
                      Icons.delete_outline,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SelectableText(
                message.email,
                style: const TextStyle(color: Color(0xff036ffc)),
              ),
              if (date != null) ...[
                const SizedBox(height: 8),
                Text(
                  '${MaterialLocalizations.of(context).formatMediumDate(date)}'
                  ' • ${TimeOfDay.fromDateTime(date).format(context)}',
                  style: const TextStyle(color: Colors.blueGrey),
                ),
              ],
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Divider(),
              ),
              SelectableText(
                message.message,
                style: const TextStyle(fontSize: 16, height: 1.5),
              ),
            ],
          ),
        );
        // Message Card End
      },
    );
  }

  // Messages List End
}

// Inbox Content End