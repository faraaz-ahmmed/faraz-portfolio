import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/auth_viewmodel.dart';
import '../views/admin_login_screen.dart';
import '../views/edit_profile_screen.dart';
import '../views/manage_projects_screen.dart';

// Portfolio Menu
class PortfolioDrawer extends StatelessWidget {
  final void Function(String section) onSelected;

  const PortfolioDrawer({
    super.key,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isAdmin = context.watch<AuthViewModel>().isAdmin;

    // Menu Options Section
    final items = {
      'Home': Icons.home_outlined,
      'About Me': Icons.person_outline,
      'Skills': Icons.code,
      'Projects': Icons.work_outline,
      'Download CV': Icons.download_outlined,
      'Contact Me': Icons.mail_outline,
      if (isAdmin) 'Edit Profile': Icons.manage_accounts_outlined,
      if (isAdmin) 'Manage Projects': Icons.folder_outlined,
      isAdmin ? 'Admin Dashboard' : 'Admin Login': Icons.lock_outline,
    };
    // Menu Options End

    return Drawer(
      backgroundColor: const Color(0xffedf3fc),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // Menu Header Section
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Text(
                'My Portfolio',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff142158),
                ),
              ),
            ),
            // Menu Header End

            // Menu Items Section
            for (final item in items.entries)
              ListTile(
                leading: Icon(
                  item.value,
                  color: const Color(0xff036ffc),
                ),
                title: Text(item.key),
                trailing: const Icon(Icons.chevron_right),
                onTap: () async {
                  final navigator = Navigator.of(context);
                  final messenger = ScaffoldMessenger.of(context);

                  navigator.pop();

                  // Edit Profile Navigation
                  if (item.key == 'Edit Profile') {
                    final saved = await navigator.push<bool>(
                      MaterialPageRoute(
                        builder: (_) => const EditProfileScreen(),
                      ),
                    );

                    if (saved == true && messenger.mounted) {
                      messenger.showSnackBar(
                        const SnackBar(
                          content: Text('Profile saved successfully.'),
                        ),
                      );
                    }
                  }
                  // Edit Profile Navigation End

                  // Manage Projects Navigation
                  else if (item.key == 'Manage Projects') {
                    navigator.push(
                      MaterialPageRoute(
                        builder: (_) => const ManageProjectsScreen(),
                      ),
                    );
                  }
                  // Manage Projects Navigation End

                  // Admin Navigation
                  else if (item.key == 'Admin Login' ||
                      item.key == 'Admin Dashboard') {
                    navigator.push(
                      MaterialPageRoute(
                        builder: (_) => const AdminLoginScreen(),
                      ),
                    );
                  }
                  // Admin Navigation End

                  // Public Sections Navigation
                  else {
                    onSelected(item.key);
                  }
                  // Public Sections Navigation End
                },
              ),
            // Menu Items End
          ],
        ),
      ),
    );
  }
}
// Portfolio Menu End