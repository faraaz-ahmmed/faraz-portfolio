import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'viewmodels/profile_viewmodel.dart';
import 'views/home_screen.dart';

// App Entry Section
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ProfileViewModel(),
      child: const PortfolioApp(),
    ),
  );
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
          seedColor: const Color(0xff087cff),
        ),
        scaffoldBackgroundColor: const Color(0xfff5f8ff),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
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