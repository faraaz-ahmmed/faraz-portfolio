import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../viewmodels/profile_viewmodel.dart';
import '../widgets/portfolio_drawer.dart';
import '../widgets/projects_section.dart';

// Home Screen
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Section Keys
  final homeKey = GlobalKey();
  final aboutKey = GlobalKey();
  final skillsKey = GlobalKey();
  final projectsKey = GlobalKey();
  // Section Keys End

  // Open Link Section
  Future<void> _openLink(String link) async {
    if (link.trim().isEmpty) {
      _showMessage('This link has not been added yet.');
      return;
    }

    final uri = Uri.tryParse(link.trim());

    if (uri == null ||
        uri.host.isEmpty ||
        (uri.scheme != 'https' && uri.scheme != 'http')) {
      _showMessage('This link is invalid.');
      return;
    }

    try {
      final opened = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
        webOnlyWindowName: '_blank',
      );

      if (!mounted) return;
      if (!opened) _showMessage('Unable to open this link.');
    } catch (_) {
      if (!mounted) return;
      _showMessage('Unable to open this link.');
    }
  }
  // Open Link End

  // Message Section
  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message)),
      );
  }
  // Message End

  // Menu Navigation Section
  void openSection(String section) {
    if (section == 'Download CV') {
      _openLink(context.read<ProfileViewModel>().profile.cvUrl);
      return;
    }

    final sections = {
      'Home': homeKey,
      'About Me': aboutKey,
      'Skills': skillsKey,
      'Projects': projectsKey,
    };

    final target = sections[section]?.currentContext;

    if (target != null) {
      Scrollable.ensureVisible(
        target,
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeInOut,
      );
      return;
    }

    _showMessage('$section will be added in the next steps.');
  }
  // Menu Navigation End

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ProfileViewModel>();
    final profile = viewModel.profile;

    // Profile Photo Section
    final localPhoto = Image.asset(
      'assets/images/profile.jpg',
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => const ColoredBox(
        color: Color(0xffe0ecff),
        child: Icon(
          Icons.person,
          size: 80,
          color: Color(0xff036ffc),
        ),
      ),
    );

    final profilePhoto = Container(
      padding: const EdgeInsets.all(8),
      decoration: const BoxDecoration(
        color: Color(0xffedf3fc),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.white,
            offset: Offset(-6, -6),
            blurRadius: 14,
          ),
          BoxShadow(
            color: Color(0xffb8c9df),
            offset: Offset(6, 6),
            blurRadius: 14,
          ),
        ],
      ),
      child: ClipOval(
        child: SizedBox.square(
          dimension: 180,
          child: profile.photoUrl.trim().isEmpty
              ? localPhoto
              : Image.network(
                  profile.photoUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => localPhoto,
                ),
        ),
      ),
    );
    // Profile Photo End

    // Introduction Section
    final introduction = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'HELLO, I’M',
          style: TextStyle(
            color: Color(0xff65758b),
            fontWeight: FontWeight.w600,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          profile.name,
          style: const TextStyle(
            fontSize: 38,
            fontWeight: FontWeight.w800,
            color: Color(0xff141421),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          profile.role,
          style: const TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.w600,
            color: Color(0xff036ffc),
          ),
        ),
        const SizedBox(height: 18),

        // Main Buttons Section
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            FilledButton.icon(
              onPressed: () => openSection('Projects'),
              icon: const Icon(Icons.work_outline),
              label: const Text('View Projects'),
            ),
            if (profile.cvUrl.trim().isNotEmpty)
              OutlinedButton.icon(
                onPressed: () => _openLink(profile.cvUrl),
                icon: const Icon(Icons.description_outlined),
                label: const Text('View CV'),
              ),
          ],
        ),
        // Main Buttons End

        // Social Links Section
        if (profile.githubUrl.trim().isNotEmpty ||
            profile.linkedinUrl.trim().isNotEmpty) ...[
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: [
              if (profile.githubUrl.trim().isNotEmpty)
                TextButton.icon(
                  onPressed: () => _openLink(profile.githubUrl),
                  icon: const Icon(Icons.code),
                  label: const Text('GitHub'),
                ),
              if (profile.linkedinUrl.trim().isNotEmpty)
                TextButton.icon(
                  onPressed: () => _openLink(profile.linkedinUrl),
                  icon: const Icon(Icons.business_center_outlined),
                  label: const Text('LinkedIn'),
                ),
            ],
          ),
        ],
        // Social Links End
      ],
    );
    // Introduction End

    return Scaffold(
      backgroundColor: const Color(0xffedf3fc),

      // App Bar Section
      appBar: AppBar(
        title: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                'assets/images/app_icon.png',
                width: 38,
                height: 38,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                profile.name,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff142158),
                ),
              ),
            ),
          ],
        ),
      ),
      // App Bar End

      // Navigation Menu Section
      endDrawer: PortfolioDrawer(onSelected: openSection),
      // Navigation Menu End

      // Page Content Section
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1000),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Profile Status Section
                  if (viewModel.isLoading)
                    const Padding(
                      padding: EdgeInsets.only(bottom: 20),
                      child: LinearProgressIndicator(),
                    ),
                  if (viewModel.loadError != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Text(
                        viewModel.loadError!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ),
                  // Profile Status End

                  // Hero Section
                  _RaisedCard(
                    key: homeKey,
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        if (constraints.maxWidth < 600) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(child: profilePhoto),
                              const SizedBox(height: 32),
                              introduction,
                            ],
                          );
                        }

                        return Row(
                          children: [
                            Expanded(child: introduction),
                            const SizedBox(width: 32),
                            profilePhoto,
                          ],
                        );
                      },
                    ),
                  ),
                  // Hero End

                  const SizedBox(height: 28),

                  // About Section
                  _RaisedCard(
                    key: aboutKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const _SectionTitle(
                          icon: Icons.person_outline,
                          title: 'About Me',
                        ),
                        const SizedBox(height: 16),
                        Text(
                          profile.bio,
                          style: const TextStyle(
                            fontSize: 16,
                            height: 1.8,
                            color: Color(0xff52647e),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // About End

                  const SizedBox(height: 28),

                  // Skills Section
                  _RaisedCard(
                    key: skillsKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const _SectionTitle(
                          icon: Icons.code,
                          title: 'My Skills',
                        ),
                        const SizedBox(height: 22),
                        Wrap(
                          spacing: 16,
                          runSpacing: 16,
                          children: [
                            for (final skill in profile.skills)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xffedf3fc),
                                  borderRadius: BorderRadius.circular(14),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.white,
                                      offset: Offset(-3, -3),
                                      blurRadius: 6,
                                    ),
                                    BoxShadow(
                                      color: Color(0xffc4d1e3),
                                      offset: Offset(3, 3),
                                      blurRadius: 6,
                                    ),
                                  ],
                                ),
                                child: Text(
                                  skill,
                                  style: const TextStyle(
                                    color: Color(0xff142158),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Skills End

                  const SizedBox(height: 28),

                  // Projects Section
                  ProjectsSection(key: projectsKey),
                  // Projects End

                  const SizedBox(height: 32),

                  // Footer Section
                  const Text(
                    'Built with Flutter',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Color(0xff65758b)),
                  ),
                  // Footer End

                  const SizedBox(height: 12),
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

// Reusable 3D Card Section
class _RaisedCard extends StatelessWidget {
  final Widget child;

  const _RaisedCard({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xffedf3fc),
        borderRadius: BorderRadius.circular(24),
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
      child: child,
    );
  }
}
// Reusable 3D Card End

// Section Title
class _SectionTitle extends StatelessWidget {
  final IconData icon;
  final String title;

  const _SectionTitle({
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xff036ffc), size: 28),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xff142158),
            ),
          ),
        ),
      ],
    );
  }
}
// Section Title End