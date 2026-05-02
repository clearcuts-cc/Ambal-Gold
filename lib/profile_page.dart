import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart'; // Import to access global languageNotifier
import 'kyc_form_page.dart';
import 'passbook_page.dart';
import 'lock_screen_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? _userName;
  String? _userPhone;
  String? _passbookID;
  DateTime? _startDate;
  bool _isLoading = true;

  // Translation Map
  static const Map<String, Map<String, String>> _localized = {
    'English': {
      'hi': 'Hi,',
      'guest': 'Guest',
      'acc_settings': 'Account settings',
      'acc_details': 'Account details',
      'acc_sub': 'Update your personal details',
      'change_pin': 'Change MPIN',
      'pin_sub': 'Manage your app security',
      'support': 'Support & more',
      'refer': 'Refer & Invite',
      'refer_sub': 'Refer and Earn now',
      'history': 'History',
      'history_sub': 'Your scheme history',
      'help': 'Help & Support',
      'help_sub': 'Customer care',
      'logout': 'Logout',
      'register': 'Register Now',
      'about': 'About Us',
      'tnc': 'T&C',
      'lang_title': 'Select Language',
      'acc_details_title': 'Account Details',
      'full_name': 'Full Name',
      'phone': 'Phone Number',
      'status': 'Account Status',
      'verified': 'Verified Member',
      'back': 'Back to Profile',
      'reg_prompt': 'Please register to view history',
    },
    'Tamil (தமிழ்)': {
      'hi': 'வணக்கம்,',
      'guest': 'விருந்தினர்',
      'acc_settings': 'கணக்கு அமைப்புகள்',
      'acc_details': 'கணக்கு விவரங்கள்',
      'acc_sub': 'தனிப்பட்ட விவரங்களைப் புதுப்பிக்கவும்',
      'change_pin': 'பின் எண்ணை மாற்றவும்',
      'pin_sub': 'பயன்பாட்டு பாதுகாப்பை நிர்வகிக்கவும்',
      'support': 'ஆதரவு மற்றும் பல',
      'refer': 'பரிந்துரைத்து அழைக்கவும்',
      'refer_sub': 'பரிந்துரைத்து சம்பாதிக்கவும்',
      'history': 'வரலாறு',
      'history_sub': 'உங்கள் திட்ட வரலாறு',
      'help': 'உதவி மற்றும் ஆதரவு',
      'help_sub': 'வாடிக்கையாளர் சேவை',
      'logout': 'வெளியேறு',
      'register': 'இப்போதே பதிவு செய்யுங்கள்',
      'about': 'எங்களைப் பற்றி',
      'tnc': 'விதிமுறைகள்',
      'lang_title': 'மொழியைத் தேர்ந்தெடுக்கவும்',
      'acc_details_title': 'கணக்கு விவரங்கள்',
      'full_name': 'முழு பெயர்',
      'phone': 'தொலைபேசி எண்',
      'status': 'கணக்கு நிலை',
      'verified': 'சரிபார்க்கப்பட்ட உறுப்பினர்',
      'back': 'சுயவிவரத்திற்குத் திரும்பு',
      'reg_prompt': 'வரலாற்றைப் பார்க்க பதிவு செய்யவும்',
    }
  };

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? dateStr = prefs.getString('start_date');
      if (mounted) {
        setState(() {
          _userName = prefs.getString('user_name');
          _userPhone = prefs.getString('user_phone');
          _passbookID = prefs.getString('passbook_id');
          if (dateStr != null) {
            _startDate = DateTime.tryParse(dateStr);
          }
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String t(String key) {
    final langMap = _localized[languageNotifier.value]; // Use global value
    if (langMap == null) return key;
    return langMap[key] ?? key;
  }

  void _showLanguagePicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(t('lang_title'), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _langTile('English'),
            _langTile('Tamil (தமிழ்)'),
          ],
        ),
      ),
    );
  }

  Widget _langTile(String lang) {
    return ListTile(
      title: Text(lang, style: TextStyle(fontWeight: languageNotifier.value == lang ? FontWeight.bold : FontWeight.normal)),
      trailing: languageNotifier.value == lang ? const Icon(Icons.check_circle, color: Color(0xFF410099)) : null,
      onTap: () async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_lang', lang);
        languageNotifier.value = lang; // This triggers global rebuild
        if (mounted) Navigator.pop(context);
      },
    );
  }

  void _showAccountDetails() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
      builder: (context) => Container(
        padding: const EdgeInsets.fromLTRB(30, 20, 30, 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 25),
            Text(t('acc_details_title'), style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 30),
            _detailRow(Icons.person_outline, t('full_name'), _userName ?? t('guest')),
            const Divider(),
            _detailRow(Icons.phone_android_outlined, t('phone'), _userPhone ?? 'Not Registered'),
            const Divider(),
            _detailRow(Icons.fingerprint_rounded, 'Passbook ID', _passbookID ?? 'Not Generated'),
            const Divider(),
            _detailRow(Icons.verified_outlined, t('status'), _userName != null ? t('verified') : t('guest')),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF410099),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                child: Text(t('back'), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF410099), size: 24),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
              Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color bgLavender = Color(0xFFF5F0FF);
    const Color primaryPurple = Color(0xFF410099);

    bool isRegistered = _userName != null && _userName!.isNotEmpty;

    return Scaffold(
      backgroundColor: bgLavender,
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator(color: primaryPurple))
        : SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  // ── Top Bar ──────────────────────────────────────────
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: const Icon(Icons.translate_rounded, color: primaryPurple, size: 28),
                      onPressed: _showLanguagePicker,
                    ),
                  ),

                  // ── Profile Header ──────────────────────────────────
                  const SizedBox(height: 10),
                  CircleAvatar(
                    radius: 55,
                    backgroundColor: Colors.grey.shade300,
                    child: const Icon(Icons.person, size: 60, color: Colors.white),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    isRegistered ? '${t('hi')} ${_userName!}' : '${t('hi')} ${t('guest')}',
                    style: GoogleFonts.outfit(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 40),

                  // ── Account Settings Section ────────────────────────
                  _buildSectionTitle(t('acc_settings')),
                  const SizedBox(height: 12),
                  _buildMenuCard([
                    _buildMenuItem(Icons.person_outline, t('acc_details'), t('acc_sub'), () => _showAccountDetails()),
                    _buildMenuItem(Icons.password_outlined, t('change_pin'), t('pin_sub'), () {}),
                  ]),

                  const SizedBox(height: 32),

                  // ── Support & More Section ──────────────────────────
                  _buildSectionTitle(t('support')),
                  const SizedBox(height: 12),
                  _buildMenuCard([
                    _buildMenuItem(Icons.favorite_outline, t('refer'), t('refer_sub'), () {}),
                    _buildMenuItem(Icons.history, t('history'), t('history_sub'), () {
                      if (isRegistered) {
                        Navigator.push(context, CupertinoPageRoute(builder: (context) => PassbookPage(
                          userName: _userName!,
                          passbookID: _passbookID ?? 'AJDGL0000000',
                          startDate: _startDate ?? DateTime.now(),
                        )));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t('reg_prompt'))));
                      }
                    }),
                    _buildMenuItem(Icons.headset_mic_outlined, t('help'), t('help_sub'), () {}),
                  ]),

                  const SizedBox(height: 40),

                  // ── Logout / Register ───────────────────────────────
                  if (isRegistered)
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton.icon(
                        onPressed: () async {
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.clear();
                          if (mounted) {
                            Navigator.pushAndRemoveUntil(
                              context, 
                              CupertinoPageRoute(builder: (context) => const LockScreenPage()),
                              (route) => false,
                            );
                          }
                        },
                        icon: Text(t('logout'), style: const TextStyle(color: primaryPurple, fontSize: 18, fontWeight: FontWeight.bold)),
                        label: const Icon(Icons.logout_rounded, color: primaryPurple),
                      ),
                    )
                  else
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          await Navigator.push(context, CupertinoPageRoute(builder: (context) => const KYCFormPage()));
                          _loadUserData();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryPurple,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        child: Text(t('register'), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      ),
                    ),

                  const SizedBox(height: 60),

                  // ── Footer ──────────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.only(bottom: 24.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildFooterLink(t('about')),
                        Text('v1.121.1 (v10)', style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
                        _buildFooterLink(t('tnc')),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildMenuCard(List<Widget> items) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 15, offset: const Offset(0, 5))],
      ),
      child: Column(children: items),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, String subtitle, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        splashColor: const Color(0xFFEFE8FF),
        highlightColor: const Color(0xFFF5F0FF),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: const Color(0xFFEFE8FF), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: const Color(0xFF410099), size: 24),
          ),
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          subtitle: Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
          trailing: const Icon(Icons.chevron_right_rounded, color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildFooterLink(String text) {
    return Container(
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey.shade400))),
      child: Text(text, style: const TextStyle(color: Color(0xFF410099), fontWeight: FontWeight.bold, fontSize: 14)),
    );
  }
}
