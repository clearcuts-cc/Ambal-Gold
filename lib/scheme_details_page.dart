import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'kyc_form_page.dart';

class SchemeDetailsPage extends StatelessWidget {
  const SchemeDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryPurple = Color(0xFF410099);
    const Color goldAccent = Color(0xFFFFD54F);

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: primaryPurple,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'Scheme Details',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    'assets/images/Poster1.jpg',
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          primaryPurple.withOpacity(0.8),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Our Savings Plans',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: primaryPurple,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Choose the plan that best fits your savings goals.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Super Gold (11 Months) Card
                  _buildSchemeCard(
                    context,
                    title: 'Super Gold',
                    duration: '11 Months',
                    description: 'Maximize your savings in a shorter duration. Get full value for your gold with added benefits.',
                    benefits: [
                      'No Making Charges',
                      'No Wastage (up to 12%)',
                      'Daily Rate Advantage',
                      'Secure Digital Passbook',
                    ],
                    primaryPurple: primaryPurple,
                    goldAccent: goldAccent,
                    isPopular: true,
                  ),

                  const SizedBox(height: 20),

                  // Standard Gold (12 Months) Card
                  _buildSchemeCard(
                    context,
                    title: 'Ambal Gold',
                    duration: '12 Months',
                    description: 'Our traditional 12-month savings plan for consistent growth and long-term planning.',
                    benefits: [
                      'Flexible Installments',
                      'Bonus at Maturity',
                      'Redeem at Showroom',
                      'Verified Purity',
                    ],
                    primaryPurple: primaryPurple,
                    goldAccent: Colors.grey.shade100,
                    isPopular: false,
                    schemeType: 'regular',
                  ),

                  const SizedBox(height: 20),

                  // Digi Gold (Daily) Card
                  _buildSchemeCard(
                    context,
                    title: 'Digi Gold',
                    duration: '12 Months - Daily',
                    description: 'Flexible daily savings plan. Start saving in gold with as little as ₹100. Save in grams or rupees daily.',
                    benefits: [
                      'Daily Savings from ₹100',
                      'Buy in Grams or Rupees',
                      'Instant Value Locking',
                      'No Fixed Monthly Burden',
                    ],
                    primaryPurple: primaryPurple,
                    goldAccent: goldAccent,
                    isPopular: false,
                    schemeType: 'digigold',
                  ),

                  const SizedBox(height: 32),

                  // General Terms
                  const Text(
                    'General Terms & Conditions',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildTermsItem('1. Gold rates are updated daily based on market values.'),
                  _buildTermsItem('2. Installments must be paid monthly to maintain maturity benefits.'),
                  _buildTermsItem('3. Redemption can be done at our Dindigul showroom upon maturity.'),
                  _buildTermsItem('4. KYC verification (Aadhaar) is mandatory for enrollment.'),
                  
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSchemeCard(
    BuildContext context, {
    required String title,
    required String duration,
    required String description,
    required List<String> benefits,
    required Color primaryPurple,
    required Color goldAccent,
    required bool isPopular,
    String? schemeType,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: primaryPurple.withOpacity(0.1), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          if (isPopular)
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: const BoxDecoration(
                  color: Color(0xFFFFD54F),
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(12)),
                ),
                child: const Text(
                  'POPULAR',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          duration,
                          style: TextStyle(
                            fontSize: 14,
                            color: primaryPurple,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const Icon(Icons.savings_outlined, color: Color(0xFFFFD54F), size: 32),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 12),
                ...benefits.map((benefit) => Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        children: [
                          const Icon(Icons.check_circle, color: Colors.green, size: 16),
                          const SizedBox(width: 10),
                          Text(
                            benefit,
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    )),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(builder: (context) => KYCFormPage(schemeType: schemeType)),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryPurple,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      elevation: 0,
                    ),
                    child: const Text(
                      'JOIN THIS SCHEME',
                      style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTermsItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: TextStyle(fontSize: 13, color: Colors.grey.shade700, height: 1.4),
      ),
    );
  }
}
