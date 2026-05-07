import 'package:flutter/material.dart';

// Global notifier to trigger app-wide rebuilds on language change
// This is the "Brain" that tells the app to switch between English and Tamil
final ValueNotifier<String> languageNotifier = ValueNotifier('English');
