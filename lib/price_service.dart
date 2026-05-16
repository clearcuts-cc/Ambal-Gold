import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'user_manager.dart';

class GoldRates {
  final double gold24k;
  final double gold22k;
  final double silver;
  final DateTime updatedAt;

  GoldRates({
    required this.gold24k,
    required this.gold22k,
    required this.silver,
    required this.updatedAt,
  });

  factory GoldRates.placeholder() {
    return GoldRates(
      gold24k: 15075,
      gold22k: 13820,
      silver: 270,
      updatedAt: DateTime.now(),
    );
  }
}

class PriceService extends ValueNotifier<GoldRates> {
  PriceService() : super(GoldRates.placeholder()) {
    _startAutoRefresh();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  Timer? _refreshTimer;

  void _startAutoRefresh() {
    // Refresh every 5 minutes
    _refreshTimer = Timer.periodic(const Duration(minutes: 5), (timer) {
      fetchRates();
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  Future<void> fetchRates() async {
    _isLoading = true;
    notifyListeners();

    try {
      // 1. Try fetching from Supabase for admin-defined rates
      try {
        final supabaseResponse = await supabase
            .from('settings')
            .select('value')
            .eq('key', 'gold_rate_22kt')
            .single();
        
        if (supabaseResponse != null) {
          double customRate = double.parse(supabaseResponse['value']);
          // If we have a custom rate, we might still want to fetch others or just use this
          value = GoldRates(
            gold24k: customRate * (24 / 22),
            gold22k: customRate,
            silver: value.silver,
            updatedAt: DateTime.now(),
          );
          // If admin override is found, we might skip external fetch or just use it as priority
        }
      } catch (se) {
        debugPrint('Supabase rate not found, using external API');
      }

      // 2. Fetch from External API
      final headers = {
        'Accept': 'application/json',
        'User-Agent': 'AmbalGoldApp/1.0',
      };
      
      final goldResponse = await http.get(
        Uri.parse('https://api.gold-api.com/price/XAU/INR'),
        headers: headers,
      );
      final silverResponse = await http.get(
        Uri.parse('https://api.gold-api.com/price/XAG/INR'),
        headers: headers,
      );

      if (goldResponse.statusCode == 200 && silverResponse.statusCode == 200) {
        final goldData = json.decode(goldResponse.body);
        final silverData = json.decode(silverResponse.body);

        double goldOuncePrice = (goldData['price'] as num).toDouble();
        double silverOuncePrice = (silverData['price'] as num).toDouble();

        // 1 Troy Ounce = 31.1035 grams
        double goldGram24k = goldOuncePrice / 31.1035;
        
        // Apply Retail Adjustment (approx 8.3% for Tamil Nadu/Dindigul market rates)
        // This accounts for Import Duty, GST, and local association premiums
        const double retailMarkup = 1.083;
        
        double goldGram22k = (goldGram24k * (22 / 24)) * retailMarkup;
        
        // Silver adjustment for Dindigul market (approx 1.11x over global spot for 2026 local retail)
        double silverGram = (silverOuncePrice / 31.1035) * 1.11;

        value = GoldRates(
          gold24k: goldGram24k * retailMarkup,
          gold22k: goldGram22k,
          silver: silverGram,
          updatedAt: DateTime.now(),
        );
      }
    } catch (e) {
      debugPrint('Error fetching rates: $e');
      // Keep previous value on error
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

final priceService = PriceService();
