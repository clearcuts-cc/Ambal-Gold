import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserState {
  String? name;
  String? phone;
  String? passbookId;
  DateTime? startDate;
  String? mpin;
  int paidCount;
  double totalWeight;
  int schemeAmount;

  UserState({
    this.name, 
    this.phone, 
    this.passbookId, 
    this.startDate, 
    this.mpin,
    this.paidCount = 0,
    this.totalWeight = 0.0,
    this.schemeAmount = 2000,
  });
}

class UserNotifier extends ValueNotifier<UserState> {
  UserNotifier() : super(UserState());

  Future<void> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    String? dateStr = prefs.getString('start_date');
    value = UserState(
      name: prefs.getString('user_name'),
      phone: prefs.getString('user_phone'),
      passbookId: prefs.getString('passbook_id'),
      startDate: dateStr != null ? DateTime.tryParse(dateStr) : null,
      mpin: prefs.getString('user_mpin'),
      paidCount: prefs.getInt('paid_count') ?? 0,
      totalWeight: prefs.getDouble('total_weight') ?? 0.0,
      schemeAmount: prefs.getInt('scheme_amount') ?? 2000,
    );
    notifyListeners();
  }

  Future<void> setUser({
    required String name,
    required String phone,
    required String passbookId,
    required DateTime startDate,
    required int schemeAmount,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', name);
    await prefs.setString('user_phone', phone);
    await prefs.setString('passbook_id', passbookId);
    await prefs.setString('start_date', startDate.toIso8601String());
    await prefs.setInt('scheme_amount', schemeAmount);
    
    value = UserState(
      name: name,
      phone: phone,
      passbookId: passbookId,
      startDate: startDate,
      mpin: value.mpin,
      paidCount: 0,
      totalWeight: 0.0,
      schemeAmount: schemeAmount,
    );
    notifyListeners();
  }

  Future<void> updateProgress(int count, double weight) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('paid_count', count);
    await prefs.setDouble('total_weight', weight);
    
    value = UserState(
      name: value.name,
      phone: value.phone,
      passbookId: value.passbookId,
      startDate: value.startDate,
      mpin: value.mpin,
      paidCount: count,
      totalWeight: weight,
    );
    notifyListeners();
  }

  Future<void> setMPIN(String pin) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_mpin', pin);
    value = UserState(
      name: value.name,
      phone: value.phone,
      passbookId: value.passbookId,
      startDate: value.startDate,
      mpin: pin,
      paidCount: value.paidCount,
      totalWeight: value.totalWeight,
      schemeAmount: value.schemeAmount,
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
    await prefs.remove('passbook_id');
    await prefs.remove('start_date');
    await prefs.remove('paid_count');
    await prefs.remove('total_weight');
    await prefs.remove('scheme_amount');
    value = UserState(mpin: value.mpin);
    notifyListeners();
  }
}

final userNotifier = UserNotifier();
