import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_page.dart';

class LockScreenPage extends StatefulWidget {
  const LockScreenPage({super.key});

  @override
  State<LockScreenPage> createState() => _LockScreenPageState();
}

class _LockScreenPageState extends State<LockScreenPage> {
  String pin = "";
  final int pinLength = 4;
  String? _savedPin;
  bool _isSettingPin = false;
  String _statusMessage = "Enter Your DigiGold PIN";
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _checkPinStatus();
  }

  Future<void> _checkPinStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString('user_pin');
    setState(() {
      _savedPin = saved;
      _isSettingPin = (saved == null);
      _statusMessage = _isSettingPin ? "Set Your New DigiGold PIN" : "Enter Your DigiGold PIN";
    });
  }

  Future<void> _savePin(String newPin) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_pin', newPin);
    if (mounted) {
      Navigator.pushReplacement(
        context,
        CupertinoPageRoute(builder: (context) => const HomePage()),
      );
    }
  }

  void _onKeyTap(String key) {
    if (pin.length < pinLength) {
      setState(() {
        pin += key;
        _hasError = false;
      });
      if (pin.length == pinLength) {
        _handlePinCompletion();
      }
    }
  }

  void _handlePinCompletion() {
    if (_isSettingPin) {
      _savePin(pin);
    } else {
      if (pin == _savedPin) {
        Navigator.pushReplacement(
          context,
          CupertinoPageRoute(builder: (context) => const HomePage()),
        );
      } else {
        // Vibrate/Shake effect here would be cool
        setState(() {
          pin = "";
          _hasError = true;
          _statusMessage = "Incorrect PIN. Try Again";
        });
      }
    }
  }

  void _onBackspace() {
    if (pin.isNotEmpty) {
      setState(() {
        pin = pin.substring(0, pin.length - 1);
        _hasError = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryPurple = Color(0xFF410099);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ──────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: primaryPurple.withOpacity(0.1),
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Image.asset('assets/images/AMBALLOGO-2.png', fit: BoxFit.contain),
                    ),
                  ),
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: primaryPurple.withOpacity(0.05),
                    child: const Icon(Icons.person_outline, color: primaryPurple, size: 22),
                  ),
                ],
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(pinLength, (index) {
                bool isSelected = pin.length == index;
                bool isFilled = pin.length > index;

                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: _hasError 
                        ? Colors.red 
                        : (isSelected ? primaryPurple : Colors.grey.shade300),
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: isFilled 
                          ? (_hasError ? Colors.red : primaryPurple) 
                          : Colors.transparent,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                );
              }),
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
                      _buildSpecialKey(Icons.check_rounded, () {
                        if (pin.length == pinLength) _handlePinCompletion();
                      }, color: pin.length == pinLength ? primaryPurple : Colors.grey.shade400),
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
    return GestureDetector(
      onTap: () => _onKeyTap(label),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 60,
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
    );
  }

  Widget _buildSpecialKey(IconData icon, VoidCallback onTap, {Color? color}) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 60,
        child: Center(
          child: Icon(icon, color: color ?? Colors.grey.shade400, size: 28),
        ),
      ),
    );
  }
}
