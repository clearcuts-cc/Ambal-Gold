import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
  String? id;
  String? name;
  String? phone;
  String? mpin;
  List<SchemeData> schemes;

  UserState({
    this.id,
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

final supabase = Supabase.instance.client;

class UserNotifier extends ValueNotifier<UserState> {
  UserNotifier() : super(UserState());

  Future<void> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final phone = prefs.getString('user_phone');
    final name = prefs.getString('user_name');
    final mpin = prefs.getString('user_mpin');

    List<SchemeData> schemes = [];

    // Sync from Supabase if we have a phone number (acting as user ID for now)
    if (phone != null) {
      try {
        final response = await supabase
            .from('schemes')
            .select()
            .eq('user_id', phone); // In a real app, use auth.uid()
        
        schemes = (response as List).map((s) => SchemeData(
          id: s['passbook_id'],
          startDate: DateTime.parse(s['start_date']),
          paidCount: s['paid_count'],
          totalWeight: (s['total_weight'] as num).toDouble(),
          schemeAmount: s['scheme_amount'],
          schemeType: s['scheme_type'],
        )).toList();
      } catch (e) {
        debugPrint('Error loading from Supabase: $e');
        // Fallback to local if offline or error
        final schemesJson = prefs.getString('user_schemes');
        if (schemesJson != null) {
          final List<dynamic> decoded = jsonDecode(schemesJson);
          schemes = decoded.map((item) => SchemeData.fromJson(item)).toList();
        }
      }
    }

    value = UserState(
      id: phone,
      name: name,
      phone: phone,
      mpin: mpin,
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

    // Update Supabase
    try {
      await supabase.from('profiles').upsert({
        'id': phone, // Using phone as ID for demo, should be auth.uid()
        'full_name': name,
        'phone_number': phone,
      });

      await supabase.from('schemes').insert({
        'user_id': phone,
        'passbook_id': passbookId,
        'start_date': startDate.toIso8601String(),
        'scheme_amount': schemeAmount,
        'scheme_type': schemeType,
      });
    } catch (e) {
      debugPrint('Error saving to Supabase: $e');
    }

    List<SchemeData> schemes = [...value.schemes, newScheme];
    await _saveSchemes(prefs, schemes);

    value = UserState(
      id: phone,
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

    // Update Supabase
    if (value.phone != null) {
      try {
        await supabase.from('schemes').insert({
          'user_id': value.phone,
          'passbook_id': passbookId,
          'start_date': startDate.toIso8601String(),
          'scheme_amount': schemeAmount,
          'scheme_type': schemeType,
        });
      } catch (e) {
        debugPrint('Error adding scheme to Supabase: $e');
      }
    }

    List<SchemeData> schemes = [...value.schemes, newScheme];
    await _saveSchemes(prefs, schemes);

    value = UserState(
      id: value.id,
      name: value.name,
      phone: value.phone,
      mpin: value.mpin,
      schemes: schemes,
    );
    notifyListeners();
  }

  Future<void> updateProgress(String schemeId, int count, double weight) async {
    final prefs = await SharedPreferences.getInstance();
    
    // Update Supabase
    if (value.phone != null) {
      try {
        await supabase
            .from('schemes')
            .update({
              'paid_count': count,
              'total_weight': weight,
            })
            .eq('passbook_id', schemeId);
        
        // Add a transaction record
        await supabase.from('transactions').insert({
          'scheme_id': (await supabase.from('schemes').select('id').eq('passbook_id', schemeId).single())['id'],
          'amount': value.getScheme(schemeId)?.schemeAmount ?? 0,
          'weight': weight - (value.getScheme(schemeId)?.totalWeight ?? 0),
          'status': 'success',
        });
      } catch (e) {
        debugPrint('Error updating progress in Supabase: $e');
      }
    }

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
      id: value.id,
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
