import 'package:flutter/material.dart';

import '../views/admin_login_screen.dart';

// Portfolio Menu
class PortfolioDrawer extends StatelessWidget {
  final void Function(String section) onSelected;

  const PortfolioDrawer({
    super.key,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    const items = {
      'Home': Icons.home_outlined,
      'About Me': Icons.person_outline,
      'Skills': Icons.code,
      'Projects': Icons.work_outline,
      'Download CV': Icons.download_outlined,
      'Contact Me': Icons.mail_outline,
      'Admin Login': Icons.lock_outline,
    };

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
                onTap: () {
                  final navigator = Navigator.of(context);
                  navigator.pop();

                  if (item.key == 'Admin Login') {
                    navigator.push(
                      MaterialPageRoute(
                        builder: (_) => const AdminLoginScreen(),
                      ),
                    );
                  } else {
                    onSelected(item.key);
                  }
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