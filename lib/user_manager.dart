import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SchemeData {
  String id;
  DateTime startDate;
  int paidCount;
  double totalWeight;
  int schemeAmount;
  String? schemeType;

  SchemeData({
    required this.id,
    required this.startDate,
    this.paidCount = 0,
    this.totalWeight = 0.0,
    required this.schemeAmount,
    this.schemeType,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'startDate': startDate.toIso8601String(),
        'paidCount': paidCount,
        'totalWeight': totalWeight,
        'schemeAmount': schemeAmount,
        'schemeType': schemeType,
      };

  factory SchemeData.fromJson(Map<String, dynamic> json) => SchemeData(
        id: json['id'],
        startDate: DateTime.parse(json['startDate']),
        paidCount: json['paidCount'] ?? 0,
        totalWeight: (json['totalWeight'] ?? 0.0).toDouble(),
        schemeAmount: json['schemeAmount'] ?? 2000,
        schemeType: json['schemeType'],
      );
}

class UserState {
  String? name;
  String? phone;
  String? mpin;
  List<SchemeData> schemes;

  UserState({
    this.name,
    this.phone,
    this.mpin,
    this.schemes = const [],
  });

  // Helper to get a scheme by ID
  SchemeData? getScheme(String id) {
    try {
      return schemes.firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }
}

class UserNotifier extends ValueNotifier<UserState> {
  UserNotifier() : super(UserState());

  Future<void> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final schemesJson = prefs.getString('user_schemes');
    List<SchemeData> schemes = [];
    if (schemesJson != null) {
      final List<dynamic> decoded = jsonDecode(schemesJson);
      schemes = decoded.map((item) => SchemeData.fromJson(item)).toList();
    }

    value = UserState(
      name: prefs.getString('user_name'),
      phone: prefs.getString('user_phone'),
      mpin: prefs.getString('user_mpin'),
      schemes: schemes,
    );
    notifyListeners();
  }

  Future<void> setUser({
    required String name,
    required String phone,
    required String passbookId,
    required DateTime startDate,
    required int schemeAmount,
    String? schemeType,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', name);
    await prefs.setString('user_phone', phone);

    final newScheme = SchemeData(
      id: passbookId,
      startDate: startDate,
      schemeAmount: schemeAmount,
      schemeType: schemeType,
    );

    List<SchemeData> schemes = [...value.schemes, newScheme];
    await _saveSchemes(prefs, schemes);

    value = UserState(
      name: name,
      phone: phone,
      mpin: value.mpin,
      schemes: schemes,
    );
    notifyListeners();
  }

  Future<void> addScheme({
    required String passbookId,
    required DateTime startDate,
    required int schemeAmount,
    String? schemeType,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final newScheme = SchemeData(
      id: passbookId,
      startDate: startDate,
      schemeAmount: schemeAmount,
      schemeType: schemeType,
    );

    List<SchemeData> schemes = [...value.schemes, newScheme];
    await _saveSchemes(prefs, schemes);

    value = UserState(
      name: value.name,
      phone: value.phone,
      mpin: value.mpin,
      schemes: schemes,
    );
    notifyListeners();
  }

  Future<void> updateProgress(String schemeId, int count, double weight) async {
    final prefs = await SharedPreferences.getInstance();
    
    List<SchemeData> schemes = value.schemes.map((s) {
      if (s.id == schemeId) {
        return SchemeData(
          id: s.id,
          startDate: s.startDate,
          paidCount: count,
          totalWeight: weight,
          schemeAmount: s.schemeAmount,
          schemeType: s.schemeType,
        );
      }
      return s;
    }).toList();

    await _saveSchemes(prefs, schemes);

    value = UserState(
      name: value.name,
      phone: value.phone,
      mpin: value.mpin,
      schemes: schemes,
    );
    notifyListeners();
  }

  Future<void> _saveSchemes(SharedPreferences prefs, List<SchemeData> schemes) async {
    final jsonStr = jsonEncode(schemes.map((s) => s.toJson()).toList());
    await prefs.setString('user_schemes', jsonStr);
  }

  Future<void> setMPIN(String pin) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_mpin', pin);
    value = UserState(
      name: value.name,
      phone: value.phone,
      mpin: pin,
      schemes: value.schemes,
    );
    notifyListeners();
  }

  Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    value = UserState();
    notifyListeners();
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_name');
    await prefs.remove('user_phone');
    await prefs.remove('user_schemes');
    value = UserState(mpin: value.mpin);
    notifyListeners();
  }
}

final userNotifier = UserNotifier();
