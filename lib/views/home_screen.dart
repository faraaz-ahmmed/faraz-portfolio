import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/profile_viewmodel.dart';

// Home Screen
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<ProfileViewModel>().profile;
    final theme = Theme.of(context);

    // Brand Image Section
    final brandImage = ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Image.asset(
        'assets/images/app_icon.png',
        width: 150,
        height: 150,
        fit: BoxFit.contain,
      ),
    );
    // Brand Image End

    // Introduction Section
    final introduction = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Hi, I’m',
          style: TextStyle(fontSize: 20),
        ),
        const SizedBox(height: 8),
        Text(
          profile.name,
          style: const TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          profile.role,
          style: TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Building clean apps with Flutter & Firebase.',
          style: TextStyle(fontSize: 16, height: 1.6),
        ),
      ],
    );
    // Introduction End

    return Scaffold(
      // App Bar Section
      appBar: AppBar(
        title: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                'assets/images/app_icon.png',
                width: 36,
                height: 36,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                profile.name,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
      // App Bar End

      // Page Content Section
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1000),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hero Section
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xffe1efff),
                          Colors.white,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        // Mobile Layout Section
                        if (constraints.maxWidth < 600) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(child: brandImage),
                              const SizedBox(height: 24),
                              introduction,
                            ],
                          );
                        }
                        // Mobile Layout End

                        // Wide Screen Layout Section
                        return Row(
                          children: [
                            Expanded(child: introduction),
                            const SizedBox(width: 24),
                            brandImage,
                          ],
                        );
                        // Wide Screen Layout End
                      },
                    ),
                  ),
                  // Hero End

                  const SizedBox(height: 32),

                  // About Section
                  Text(
                    'About Me',
                    style: theme.textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    profile.bio,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.7,
                    ),
                  ),
                  // About End

                  const SizedBox(height: 28),

                  // Skills Section
                  Text(
                    'My Skills',
                    style: theme.textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    runSpacing: 8,
                    children: [
                      for (final skill in profile.skills)
                        Chip(label: Text(skill)),
                    ],
                  ),
                  // Skills End

                  const SizedBox(height: 40),

                  // Footer Section
                  const Center(
                    child: Text(
                      'Built with Flutter',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  // Footer End
                ],
              ),
            ),
          ),
        ),
      ),
      // Page Content End
    );
  }
}
// Home Screen End