import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'lock_screen_page.dart';

// Global notifier to trigger app-wide rebuilds on language change
final ValueNotifier<String> languageNotifier = ValueNotifier('English');

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  languageNotifier.value = prefs.getString('user_lang') ?? 'English';
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
          home: const LockScreenPage(),
        );
      },
    );
  }
}
