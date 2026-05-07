import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'lock_screen_page.dart';
import 'splash_screen.dart';
import 'language_manager.dart';
import 'user_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
