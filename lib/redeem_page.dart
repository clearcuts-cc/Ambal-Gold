import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'user_manager.dart';

class RedeemPage extends StatelessWidget {
  final double totalWeight;
  final String passbookID;

  const RedeemPage({
    super.key,
    required this.totalWeight,
    required this.passbookID,
  });

  @override
  Widget build(BuildContext context) {
    const Color primaryPurple = Color(0xFF410099);
    const Color goldAccent = Color(0xFFFFC107);

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: primaryPurple,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text('Scheme Redemption', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [primaryPurple, Color(0xFF6A1B9A)],
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: goldAccent.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.stars_rounded, color: goldAccent, size: 60),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Congratulations!',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'You have successfully completed your 12-month savings journey with Ambal Gold.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600, height: 1.5),
                  ),
                  const SizedBox(height: 32),
                  
                  // Gold Weight Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.yellow.shade700, Colors.yellow.shade600],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.yellow.shade700.withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'TOTAL GOLD SAVED',
                          style: TextStyle(color: Colors.black54, fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: 1),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '${totalWeight.toStringAsFixed(3)} Grams',
                          style: const TextStyle(color: Colors.black, fontSize: 32, fontWeight: FontWeight.w900),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Pure 22KT Gold',
                          style: TextStyle(color: Colors.black45, fontSize: 14, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // Steps to redeem
                  _buildStep(1, 'Visit our Showroom', 'Head over to our Dindigul showroom with your mobile phone.'),
                  _buildStep(2, 'Show Digital Passbook', 'Present your passbook ID ($passbookID) to our staff.'),
                  _buildStep(3, 'Verify & Collect', 'Verify your identity and collect your beautiful gold jewelry.'),
                  
                  const SizedBox(height: 40),
                  
                  // Showroom Info
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.location_on, color: primaryPurple, size: 20),
                            SizedBox(width: 12),
                            Text('Main Showroom', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '99/1, Main Road, Begambur, Dindigul, Tamil Nadu - 624001',
                          style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () {},
                                icon: const Icon(Icons.directions, size: 18),
                                label: const Text('Directions'),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: primaryPurple,
                                  side: const BorderSide(color: primaryPurple),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () {},
                                icon: const Icon(Icons.call, size: 18),
                                label: const Text('Call Now'),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: primaryPurple,
                                  side: const BorderSide(color: primaryPurple),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // Redeem Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please visit the showroom to complete redemption.')),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: goldAccent,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 0,
                      ),
                      child: const Text('READY TO COLLECT', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16, letterSpacing: 1)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Back to Home', style: TextStyle(color: Colors.grey)),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep(int num, String title, String desc) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: const BoxDecoration(
              color: Color(0xFF410099),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$num',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                Text(desc, style: TextStyle(color: Colors.grey.shade600, fontSize: 13, height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
