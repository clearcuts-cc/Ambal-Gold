import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'lock_screen_page.dart';
import 'splash_screen.dart';
import 'language_manager.dart';
import 'user_manager.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Supabase initialization with provided credentials
  await Supabase.initialize(
    url: 'https://decmmsfawbzyeonnicgu.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRlY21tc2Zhd2J6eWVvbm5pY2d1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Nzg5MDQyNTAsImV4cCI6MjA5NDQ4MDI1MH0.wvHzjPmk_h3snv8BIrX9J3LeN7FMAfIsU5BLtQMFNmg',
  );

  final prefs = await SharedPreferences.getInstance();
  languageNotifier.value = prefs.getString('user_lang') ?? 'English';
  await userNotifier.loadUser();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: languageNotifier,
      builder: (context, lang, child) {
        return MaterialApp(
          key: ValueKey(lang), // Force app rebuild on language change
          title: 'Ambal Gold',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFE09200)),
          ),
          home: const SplashScreen(),
        );
      },
    );
  }
}
