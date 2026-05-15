import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'digigold_payment_page.dart';
import 'user_manager.dart';

class DigiGoldPassbookPage extends StatefulWidget {
  final String userName;
  final String passbookID;
  final DateTime startDate;

  const DigiGoldPassbookPage({
    super.key,
    required this.userName,
    required this.passbookID,
    required this.startDate,
  });

  @override
  State<DigiGoldPassbookPage> createState() => _DigiGoldPassbookPageState();
}

class _DigiGoldPassbookPageState extends State<DigiGoldPassbookPage> {
  int selectedMonthIndex = 7; // Aug (index 7) as per screenshot
  static const Color primaryPurple = Color(0xFF410099);
  static const Color lightPurple = Color(0xFF7E57C2);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: userNotifier,
      builder: (context, userState, child) {
        final currentScheme = userState.getScheme(widget.passbookID);
        final totalWeight = currentScheme?.totalWeight ?? 0.0;
        final totalAmountPaid = totalWeight * 9225; // Simple estimation using mock rate
        
        return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: primaryPurple,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('scheme passbook', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Passbook Card
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              height: 200,
              decoration: BoxDecoration(
                color: lightPurple.withOpacity(0.9),
                borderRadius: BorderRadius.circular(24),
                image: const DecorationImage(
                  image: AssetImage('assets/images/4614.jpg'),
                  opacity: 0.1,
                  repeat: ImageRepeat.repeat,
                ),
              ),
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(widget.userName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                            Text(widget.passbookID, style: const TextStyle(color: Colors.white70, fontSize: 11, letterSpacing: 1)),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildCardMetric('TOTAL AMOUNT PAID', '₹${totalAmountPaid.toStringAsFixed(0)}'),
                            _buildCardMetric('AVERAGE RATE / g', '₹8900'),
                          ],
                        ),
                        const Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildMetricBox('BENEFIT EARNED*', '${(totalWeight * 0.05).toStringAsFixed(3)} gram'),
                            _buildMetricBox('REWARDS EARNED*', '${(totalWeight * 0.02).toStringAsFixed(3)} gram'),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildDateColumn('Date of Joining', '25-Aug-2025'),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: primaryPurple,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.white30),
                              ),
                              child: const Row(
                                children: [
                                  Icon(Icons.logout, color: Colors.white, size: 12),
                                  SizedBox(width: 4),
                                  Text('close and redeem now', style: TextStyle(color: Colors.white, fontSize: 9)),
                                ],
                              ),
                            ),
                            _buildDateColumn('Date of maturity', '25-Aug-2025'),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Center Weight Circle
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('TOTAL', style: TextStyle(fontSize: 6, fontWeight: FontWeight.bold)),
                          const Text('WEIGHT SAVED', style: TextStyle(fontSize: 6, fontWeight: FontWeight.bold)),
                          Text('${totalWeight.toStringAsFixed(3)} g', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Month Selector
          SizedBox(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: 12,
              itemBuilder: (context, index) {
                final months = ['jan', 'feb', 'mar', 'apr', 'may', 'jun', 'jul', 'aug', 'sep', 'oct', 'nov', 'dec'];
                bool isSelected = index == selectedMonthIndex;
                return Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: InkWell(
                    onTap: () => setState(() => selectedMonthIndex = index),
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: isSelected ? primaryPurple : Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Center(
                        child: Text(
                          months[index],
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 20),

          // Tabs
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Container(
              height: 45,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5),
                        ],
                      ),
                      child: const Center(child: Text('RECIPTS', style: TextStyle(fontWeight: FontWeight.bold))),
                    ),
                  ),
                  Expanded(
                    child: Center(child: Text('REWARDS', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey))),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Transaction History
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Truncation history', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 12),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Status', style: TextStyle(color: Colors.grey, fontSize: 12)),
                      Text('Date', style: TextStyle(color: Colors.grey, fontSize: 12)),
                      Text('Amount', style: TextStyle(color: Colors.grey, fontSize: 12)),
                      Text('Saved Weight', style: TextStyle(color: Colors.grey, fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildTransactionItem(true, '09.08.25', '₹105', '0.011g'),
                  _buildTransactionItem(false, '09.08.25', '₹105', '0.011g'),
                ],
              ),
            ),
          ),

          // Bottom Button
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => DigiGoldPaymentPage(
                            userName: widget.userName,
                            passbookID: widget.passbookID,
                          ),
                        ),
                      );
                      if (result == true) {
                        // Refresh data
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: lightPurple,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('pay now', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: const Text('REDEEM NOW', style: TextStyle(color: primaryPurple, fontWeight: FontWeight.bold)),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text('How to Redeem ?', style: TextStyle(color: Colors.grey, fontSize: 12)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
      },
    );
  }

  Widget _buildCardMetric(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 9, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900)),
      ],
    );
  }

  Widget _buildMetricBox(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 8)),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildDateColumn(String label, String date) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 7)),
        Text(date, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildTransactionItem(bool success, String date, String amount, String weight) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: primaryPurple.withOpacity(0.5)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(success ? Icons.check_circle : Icons.cancel, color: success ? Colors.green : Colors.red, size: 20),
          Text(date, style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(amount, style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(weight, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
