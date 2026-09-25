import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'viewmodels/profile_viewmodel.dart';
import 'viewmodels/project_viewmodel.dart';
import 'views/home_screen.dart';

// App Entry Section
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase Setup Section
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Firebase Setup End

  // Providers Section
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ProfileViewModel(),
        ),
        ChangeNotifierProvider(
          create: (_) => ProjectViewModel(),
        ),
      ],
      child: const PortfolioApp(),
    ),
  );
  // Providers End
}
// App Entry End

// Portfolio App
class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Faraz Ahmad | Portfolio',

      // Theme Section
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xff036ffc),
        ),
        scaffoldBackgroundColor: const Color(0xffedf3fc),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xffedf3fc),
          surfaceTintColor: Colors.transparent,
          centerTitle: false,
        ),
      ),
      // Theme End

      // Home Section
      home: const HomeScreen(),
      // Home End
    );
  }
}
// Portfolio App End