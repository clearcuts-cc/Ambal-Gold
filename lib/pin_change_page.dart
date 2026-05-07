import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PinChangePage extends StatefulWidget {
  const PinChangePage({super.key});

  @override
  State<PinChangePage> createState() => _PinChangePageState();
}

class _PinChangePageState extends State<PinChangePage> {
  final TextEditingController _oldPin = TextEditingController();
  final TextEditingController _newPin = TextEditingController();
  final TextEditingController _confirmPin = TextEditingController();

  @override
  Widget build(BuildContext context) {
    const Color primaryPurple = Color(0xFF410099);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Change MPIN',
          style: GoogleFonts.outfit(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            _buildInfoCard(),
            const SizedBox(height: 32),
            _buildPinField('Current MPIN', _oldPin, 'Enter your existing 4-digit PIN'),
            const SizedBox(height: 24),
            _buildPinField('New MPIN', _newPin, 'Enter your new 4-digit PIN'),
            const SizedBox(height: 24),
            _buildPinField('Confirm New MPIN', _confirmPin, 'Re-enter your new 4-digit PIN'),
            const SizedBox(height: 48),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _handlePinChange,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryPurple,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: const Text(
                  'Update MPIN',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF410099).withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF410099).withOpacity(0.1)),
      ),
      child: Row(
        children: [
          const Icon(Icons.security_outlined, color: Color(0xFF410099)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Your MPIN is used to secure your transactions and access your account.',
              style: GoogleFonts.outfit(fontSize: 13, color: Colors.grey[700]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPinField(String label, TextEditingController controller, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: controller,
          obscureText: true,
          keyboardType: TextInputType.number,
          maxLength: 4,
          style: const TextStyle(letterSpacing: 20, fontSize: 24, fontWeight: FontWeight.bold),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(letterSpacing: 0, fontSize: 14, fontWeight: FontWeight.normal, color: Colors.grey[400]),
            counterText: '',
            filled: true,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[200]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF410099), width: 1.5),
            ),
          ),
        ),
      ],
    );
  }

  void _handlePinChange() {
    if (_oldPin.text.length < 4 || _newPin.text.length < 4 || _confirmPin.text.length < 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter all 4 digits for each field.')),
      );
      return;
    }

    if (_newPin.text != _confirmPin.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('New PINs do not match.')),
      );
      return;
    }

    // Success simulation
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 60),
            const SizedBox(height: 16),
            const Text('PIN Updated Successfully!', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF410099),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Back to Profile', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
