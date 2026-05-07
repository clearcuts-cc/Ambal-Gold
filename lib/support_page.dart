import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'language_manager.dart'; // For languageNotifier
import 'notification_service.dart';

class SupportPage extends StatefulWidget {
  const SupportPage({super.key});

  @override
  State<SupportPage> createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {
  // Global Translations for SupportPage
  static const Map<String, Map<String, String>> _localized = {
    'English': {
      'title': 'Help & Support',
      'subtitle': 'We are here to help you!',
      'contact_us': 'Contact Us',
      'call': 'Call Support',
      'whatsapp': 'Chat on WhatsApp',
      'email': 'Email Us',
      'faq_title': 'Frequently Asked Questions',
      'q1': 'How to pay monthly installments?',
      'a1': 'You can pay directly through the app using the "Pay Now" button on your Digital Passbook.',
      'q2': 'What happens if I miss a payment?',
      'a2': 'No worries! You can pay it later, but the gold rate will be applied based on the payment date.',
      'q3': 'How to redeem my gold?',
      'a3': 'After 12 months, visit our showroom with your digital passbook to redeem your gold jewelry.',
      'feedback': 'Send Feedback',
      'msg_hint': 'Type your message here...',
      'submit': 'Submit Feedback',
    },
    'Tamil (தமிழ்)': {
      'title': 'உதவி மற்றும் ஆதரவு',
      'subtitle': 'நாங்கள் உங்களுக்கு உதவ இங்கே இருக்கிறோம்!',
      'contact_us': 'எங்களைத் தொடர்பு கொள்ளுங்கள்',
      'call': 'அழைப்பு ஆதரவு',
      'whatsapp': 'வாட்ஸ்அப்பில் அரட்டையடிக்கவும்',
      'email': 'மின்னஞ்சல் அனுப்பவும்',
      'faq_title': 'அடிக்கடி கேட்கப்படும் கேள்விகள்',
      'q1': 'மாதாந்திர தவணைகளை எவ்வாறு செலுத்துவது?',
      'a1': 'உங்கள் டிஜிட்டல் பாஸ்புக்கில் உள்ள "இப்போது செலுத்து" பொத்தானைப் பயன்படுத்தி நேரடியாகச் செலுத்தலாம்.',
      'q2': 'நான் ஒரு தவணையைத் தவறவிட்டால் என்ன நடக்கும்?',
      'a2': 'கவலைப்பட வேண்டாம்! நீங்கள் அதை பிறகு செலுத்தலாம், ஆனால் பணம் செலுத்தும் தேதியின்படி தங்கத்தின் விலை கணக்கிடப்படும்.',
      'q3': 'எனது தங்கத்தை எவ்வாறு பெறுவது?',
      'a3': '12 மாதங்களுக்குப் பிறகு, உங்கள் தங்க நகைகளைப் பெற உங்கள் டிஜிட்டல் பாஸ்புக்குடன் எங்கள் காட்சியறைக்கு வரவும்.',
      'feedback': 'கருத்துக்களை அனுப்பவும்',
      'msg_hint': 'உங்கள் செய்தியை இங்கே தட்டச்சு செய்யவும்...',
      'submit': 'கருத்தைச் சமர்ப்பிக்கவும்',
    }
  };

  String t(String key) {
    final langMap = _localized[languageNotifier.value];
    return langMap?[key] ?? key;
  }

  @override
  Widget build(BuildContext context) {
    const Color bgLavender = Color(0xFFF5F0FF);
    const Color primaryPurple = Color(0xFF410099);

    return Scaffold(
      backgroundColor: bgLavender,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false, // Remove back button as it's now a tab
        title: Text(
          t('title'),
          style: GoogleFonts.outfit(color: primaryPurple, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              t('subtitle'),
              style: const TextStyle(fontSize: 16, color: Colors.grey, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 30),

            // ── Quick Contact Buttons ─────────────────────────────
            _buildContactCard(
              icon: Icons.phone_in_talk_outlined,
              title: t('call'),
              color: Colors.blue.shade600,
              onTap: () {},
            ),
            const SizedBox(height: 16),
            _buildContactCard(
              icon: Icons.chat_outlined,
              title: t('whatsapp'),
              color: Colors.green.shade600,
              onTap: () {},
            ),
            const SizedBox(height: 16),
            _buildContactCard(
              icon: Icons.email_outlined,
              title: t('email'),
              color: Colors.orange.shade700,
              onTap: () {},
            ),

            const SizedBox(height: 40),

            // ── FAQ Section ──────────────────────────────────────
            Text(
              t('faq_title'),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryPurple),
            ),
            const SizedBox(height: 16),
            _buildFAQTile(t('q1'), t('a1')),
            _buildFAQTile(t('q2'), t('a2')),
            _buildFAQTile(t('q3'), t('a3')),

            const SizedBox(height: 40),

            // ── Feedback Section ──────────────────────────────────
            Text(
              t('feedback'),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryPurple),
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 15, offset: const Offset(0, 5))],
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: t('msg_hint'),
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Feedback submitted!')));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryPurple,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text(t('submit'), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            
            // ── Simulation Section ─────────────────────────────
            Center(
              child: TextButton.icon(
                onPressed: () {
                  RealNotificationService.showRealNotification(
                    context: context,
                    title: 'Special Gold Offer! ✨',
                    message: 'Get extra 50 coins on your next installment. Valid for 24 hours!',
                  );
                },
                icon: const Icon(Icons.notifications_active_outlined, color: primaryPurple),
                label: const Text(
                  'Simulate Real Notification',
                  style: TextStyle(color: primaryPurple, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  Widget _buildContactCard({required IconData icon, required String title, required Color color, required VoidCallback onTap}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 15, offset: const Offset(0, 5))],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                  child: Icon(icon, color: color, size: 24),
                ),
                const SizedBox(width: 16),
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const Spacer(),
                const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFAQTile(String question, String answer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 15, offset: const Offset(0, 5))],
      ),
      child: ExpansionTile(
        title: Text(question, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87)),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        expandedAlignment: Alignment.centerLeft,
        iconColor: const Color(0xFF410099),
        collapsedIconColor: Colors.grey,
        shape: const RoundedRectangleBorder(side: BorderSide.none),
        children: [
          Text(answer, style: const TextStyle(color: Colors.grey, fontSize: 14, height: 1.5)),
        ],
      ),
    );
  }
}
