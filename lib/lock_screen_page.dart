import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_page.dart';

class LockScreenPage extends StatefulWidget {
  const LockScreenPage({super.key});

  @override
  State<LockScreenPage> createState() => _LockScreenPageState();
}

class _LockScreenPageState extends State<LockScreenPage> {
  static const Color primaryPurple = Color(0xFF410099);
  static const Color primaryPurpleLight = Color(0x1A410099); // 0.1 opacity
  static const Color primaryPurpleUltraLight = Color(0x0D410099); // 0.05 opacity
  
  final ValueNotifier<String> _pinNotifier = ValueNotifier<String>("");
  String get pin => _pinNotifier.value;
  final int pinLength = 4;
  String? _savedPin;
  bool _isSettingPin = false;
  String? _firstPinAttempt; // For confirmation flow
  String _statusMessage = "Enter Your DigiGold PIN";
  bool _hasError = false;
  bool _isVerifying = false;

  @override
  void dispose() {
    _pinNotifier.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _checkPinStatus();
  }

  Future<void> _checkPinStatus() async {
    final prefs = await SharedPreferences.getInstance();
    
    // To satisfy the "remove all account data" request, I'll clear data if it's the first run with this new code
    // bool isFirstRun = prefs.getBool('v3_reset') ?? true;
    // if (isFirstRun) {
    //   await prefs.clear();
    //   await prefs.setBool('v3_reset', false);
    // }

    final saved = prefs.getString('user_pin');
    setState(() {
      _savedPin = saved;
      _isSettingPin = (saved == null);
      _statusMessage = _isSettingPin ? "Create Your DigiGold PIN" : "Enter Your DigiGold PIN";
    });
  }

  Future<void> _savePin(String newPin) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_pin', newPin);
    if (mounted) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const HomePage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.95, end: 1.0).animate(
                  CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
                ),
                child: child,
              ),
            );
          },
          transitionDuration: const Duration(milliseconds: 350),
        ),
      );
    }
  }

  void _onKeyTap(String key) {
    if (pin.length < pinLength) {
      _pinNotifier.value = pin + key;
      if (_hasError) {
        setState(() {
          _hasError = false;
        });
      }
      // Removed HapticFeedback to ensure absolute maximum speed
      if (pin.length == pinLength) {
        // Use post frame callback to ensure the 4th dot is visible before we process completion
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) _handlePinCompletion();
        });
      }
    }
  }

  void _handlePinCompletion() {
    if (_isSettingPin) {
      if (_firstPinAttempt == null) {
        // First entry done, ask for confirmation
        setState(() {
          _firstPinAttempt = pin;
          _pinNotifier.value = "";
          _statusMessage = "Confirm Your New PIN";
        });
      } else {
        // Second entry done, check if match
        if (pin == _firstPinAttempt) {
          _savePin(pin);
        } else {
          // No match, reset
          setState(() {
            _firstPinAttempt = null;
            _pinNotifier.value = "";
            _hasError = true;
            _statusMessage = "PINs do not match. Start over.";
          });
          HapticFeedback.heavyImpact();
        }
      }
    } else {
      if (pin == _savedPin) {
        setState(() {
          _isVerifying = true;
        });
        
        // Navigate and purge the lock screen from memory instantly
        Future.microtask(() {
          if (mounted) {
            Navigator.of(context).pushAndRemoveUntil(
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) => const HomePage(),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
                transitionDuration: const Duration(milliseconds: 200),
              ),
              (route) => false,
            );
          }
        });
      } else {
        setState(() {
          _pinNotifier.value = "";
          _hasError = true;
          _statusMessage = "Incorrect PIN. Try Again";
        });
        HapticFeedback.vibrate();
      }
    }
  }

  void _onBackspace() {
    if (pin.isNotEmpty) {
      _pinNotifier.value = pin.substring(0, pin.length - 1);
      if (_hasError) {
        setState(() {
          _hasError = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ── Header (Wrapped in RepaintBoundary for speed) ──────────────
            RepaintBoundary(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: primaryPurpleLight,
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Image.asset('assets/images/AMBALLOGO-2.png', fit: BoxFit.contain),
                      ),
                    ),
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: primaryPurpleUltraLight,
                      child: Icon(Icons.person_outline, color: primaryPurple, size: 22),
                    ),
                  ],
                ),
              ),
            ),

            const Spacer(flex: 2),

            // ── Greeting & Instructions ────────────────────────────────
            const Text(
              'Hi, User',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _statusMessage,
              style: TextStyle(
                fontSize: 14,
                color: _hasError ? Colors.red : Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 40),

            // ── PIN Input Boxes ───────────────────────────────────────
            ValueListenableBuilder<String>(
              valueListenable: _pinNotifier,
              builder: (context, currentPin, _) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(pinLength, (index) {
                    bool isActive = index < currentPin.length;
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _hasError 
                          ? Colors.red 
                          : (isActive ? primaryPurple : Colors.grey[300]),
                        border: Border.all(
                          color: isActive ? primaryPurple : Colors.grey[400]!,
                          width: 1.5,
                        ),
                      ),
                    );
                  }),
                );
              },
            ),

            const SizedBox(height: 40),

            // ── Face ID Link ──────────────────────────────────────────
            if (!_isSettingPin)
              TextButton(
                onPressed: () {},
                child: const Text(
                  'Use Face ID',
                  style: TextStyle(
                    color: primaryPurple,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),

            const Spacer(flex: 3),

            // ── Numeric Keypad ────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              child: Column(
                children: [
                  _buildKeypadRow(['1', '2', '3']),
                  const SizedBox(height: 24),
                  _buildKeypadRow(['4', '5', '6']),
                  const SizedBox(height: 24),
                  _buildKeypadRow(['7', '8', '9']),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildSpecialKey(Icons.backspace_outlined, _onBackspace),
                      _buildNumberKey('0'),
                      _buildSpecialKey(
                        _isVerifying ? Icons.hourglass_top_rounded : Icons.check_rounded, 
                        () {
                          if (pin.length == pinLength && !_isVerifying) _handlePinCompletion();
                        }, 
                        color: pin.length == pinLength ? primaryPurple : Colors.grey.shade400
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildKeypadRow(List<String> keys) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: keys.map((key) => _buildNumberKey(key)).toList(),
    );
  }

  Widget _buildNumberKey(String label) {
    return Material(
      color: Colors.transparent,
      child: InkResponse(
        onTap: () => _onKeyTap(label),
        radius: 35,
        highlightColor: primaryPurple.withOpacity(0.1),
        splashColor: primaryPurple.withOpacity(0.2),
        child: SizedBox(
          width: 70,
          height: 70,
          child: Center(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSpecialKey(IconData icon, VoidCallback onTap, {Color color = Colors.black54}) {
    return Material(
      color: Colors.transparent,
      child: InkResponse(
        onTap: () {
          HapticFeedback.mediumImpact();
          onTap();
        },
        radius: 35,
        highlightColor: primaryPurple.withOpacity(0.1),
        splashColor: primaryPurple.withOpacity(0.2),
        child: SizedBox(
          width: 70,
          height: 70,
          child: Center(
            child: Icon(icon, size: 28, color: color),
          ),
        ),
      ),
    );
  }

}
