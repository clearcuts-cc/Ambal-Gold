import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import 'passbook_page.dart';

class KYCFormPage extends StatefulWidget {
  const KYCFormPage({super.key});

  @override
  State<KYCFormPage> createState() => _KYCFormPageState();
}

class _KYCFormPageState extends State<KYCFormPage> {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _aadhaarController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  final List<String> _titles = [
    "Welcome!",
    "Security First",
    "Let's get started",
    "Nearly there",
    "Home sweet home",
  ];

  void _nextStep() {
    // Validation
    if (_currentStep == 0 && _phoneController.text.length != 10) return;
    if (_currentStep == 1 && _otpController.text.length != 4) return;
    if (_currentStep == 3 && _aadhaarController.text.length != 12) return;
    if (_currentStep == 2 && _nameController.text.isEmpty) return;
    if (_currentStep == 4 && _addressController.text.isEmpty) return;

    if (_currentStep < 4) {
      setState(() {
        _currentStep++;
      });
      _pageController.nextPage(
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutCubic,
      );
    } else {
      _finishRegistration();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _pageController.previousPage(
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutCubic,
      );
    } else {
      Navigator.pop(context);
    }
  }

  String _generatePassbookID() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final rnd = Random();
    String randomStr = String.fromCharCodes(Iterable.generate(
        7, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
    return "AJDGL$randomStr";
  }

  Future<void> _finishRegistration() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(color: Color(0xFF410099), strokeWidth: 3),
              SizedBox(height: 20),
              Text('Generating Passbook...', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF410099))),
            ],
          ),
        ),
      ),
    );

    // Save to SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    String passbookID = _generatePassbookID();
    String startDate = DateTime.now().toIso8601String();
    
    await prefs.setString('user_name', _nameController.text);
    await prefs.setString('user_phone', _phoneController.text);
    await prefs.setString('passbook_id', passbookID);
    await prefs.setString('start_date', startDate);

    if (mounted) {
      Navigator.pop(context); // Close loading dialog
      // Return data to HomePage
      Navigator.pop(context, {
        'id': passbookID,
        'name': _nameController.text,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryPurple = Color(0xFF410099);
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87, size: 20),
          onPressed: _previousStep,
        ),
        title: Text(
          _titles[_currentStep],
          style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            // 1. Center Content (Scrollable to prevent overflow)
            Positioned.fill(
              bottom: 120, // Reduced space to give input more room
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.only(top: 40), // Spacing from header
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    transitionBuilder: (Widget child, Animation<double> animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          position: Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(animation),
                          child: child,
                        ),
                      );
                    },
                    child: _buildCenterInfo(),
                  ),
                ),
              ),
            ),

            // 2. Bottom Inputs (Fixed at bottom)
            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                height: 120, // Fixed height for input area
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildBottomInput(
                      0,
                      _phoneController,
                      'Phone Number',
                      TextInputType.phone,
                      prefix: '+91 ',
                      hint: '00000 00000',
                      maxLength: 10,
                    ),
                    _buildBottomInput(
                      1,
                      _otpController,
                      'Enter 4-digit OTP',
                      TextInputType.number,
                      hint: '0000',
                      maxLength: 4,
                    ),
                    _buildBottomInput(
                      2,
                      _nameController,
                      'Full Name',
                      TextInputType.name,
                      hint: 'Enter your name',
                    ),
                    _buildBottomInput(
                      3,
                      _aadhaarController,
                      'Aadhaar Number',
                      TextInputType.number,
                      hint: '0000 0000 0000',
                      maxLength: 12,
                    ),
                    _buildBottomInput(
                      4,
                      _addressController,
                      'Full Address',
                      TextInputType.multiline,
                      hint: 'Street, City, Pincode...',
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
            ),

            // Floating Next Button (Bottom Right)
            Positioned(
              right: 20,
              bottom: 20,
              child: FloatingActionButton(
                onPressed: _nextStep,
                backgroundColor: primaryPurple,
                child: Icon(
                  _currentStep == 4 ? Icons.check : Icons.arrow_forward_ios_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCenterInfo() {
    String name = _nameController.text;
    
    switch (_currentStep) {
      case 0:
        return _buildInfoCard(
          "Savings started\nwith a tap",
          "Join 10,000+ members saving in 24K Gold daily. Secure your future with Ambal Gold.",
          Icons.auto_graph_rounded,
        );
      case 1:
        return _buildInfoCard(
          "Secure Access",
          "We've sent a code to your phone. This ensures your account and gold stay protected.",
          Icons.verified_user_rounded,
        );
      case 2:
        return _buildInfoCard(
          "Personalize",
          "What should we call you? Your name will be printed on your digital gold passbook.",
          Icons.badge_rounded,
        );
      case 3:
        return _buildInfoCard(
          "Hi ${name.isNotEmpty ? name : 'there'}!",
          "Great to have you! Now we just need your Aadhaar number for KYC verification.",
          Icons.security_rounded,
        );
      case 4:
        return _buildInfoCard(
          "Final Step",
          "We need your address for physical gold delivery and documentation purposes.",
          Icons.location_on_rounded,
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildInfoCard(String title, String desc, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Allow it to shrink
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF410099).withOpacity(0.05),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: const Color(0xFF410099), size: 50),
          ),
          const SizedBox(height: 24),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: -0.5),
          ),
          const SizedBox(height: 12),
          Text(
            desc,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15, color: Colors.grey.shade600, height: 1.5),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildBottomInput(int index, TextEditingController controller, String label, TextInputType type, {String? prefix, String? hint, int maxLines = 1, int? maxLength}) {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.fromLTRB(24, 0, 100, 12), // Reduced bottom padding
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: Colors.grey.shade500, letterSpacing: 1.2),
          ),
          const SizedBox(height: 4),
          TextField(
            controller: controller,
            autofocus: true,
            keyboardType: type,
            maxLines: maxLines,
            maxLength: maxLength,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            onChanged: (val) {
              if (index == 2) setState(() {}); // Update greeting real-time
            },
            inputFormatters: (type == TextInputType.number || type == TextInputType.phone)
                ? [FilteringTextInputFormatter.digitsOnly]
                : null,
            decoration: InputDecoration(
              hintText: hint,
              prefixText: prefix,
              contentPadding: EdgeInsets.zero,
              isDense: true,
              counterText: "", // Hide character counter
              border: InputBorder.none,
              hintStyle: TextStyle(color: Colors.grey.shade300, fontWeight: FontWeight.normal),
              prefixStyle: const TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 4),
          Container(height: 2, width: 40, color: const Color(0xFF410099)),
        ],
      ),
    );
  }
}
