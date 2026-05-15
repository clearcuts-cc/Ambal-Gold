import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'user_manager.dart';

class DigiGoldPaymentPage extends StatefulWidget {
  final String userName;
  final String passbookID;

  const DigiGoldPaymentPage({
    super.key,
    required this.userName,
    required this.passbookID,
  });

  @override
  State<DigiGoldPaymentPage> createState() => _DigiGoldPaymentPageState();
}

class _DigiGoldPaymentPageState extends State<DigiGoldPaymentPage> {
  bool isBuyInRupees = true;
  final TextEditingController _amountController = TextEditingController(text: "100");
  double goldRate = 9225.0; // As per screenshot
  double benefitPercent = 5.0;

  static const Color primaryPurple = Color(0xFF410099);
  static const Color lightPurple = Color(0xFF7E57C2);

  @override
  Widget build(BuildContext context) {

    double amount = double.tryParse(_amountController.text) ?? 0.0;
    double grams = isBuyInRupees ? amount / goldRate : amount;
    if (!isBuyInRupees) {
      amount = grams * goldRate;
    }
    
    double benefitAmount = amount * (benefitPercent / 100);
    double totalValue = amount + benefitAmount;
    double totalGrams = totalValue / goldRate;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: primaryPurple,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Digigold - Payment', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Header Info
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            color: primaryPurple,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(widget.userName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                Text(widget.passbookID, style: const TextStyle(color: Colors.white70, fontSize: 12, letterSpacing: 1)),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Gold Rate Section
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text('Gold Rate 22KT ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                Container(width: 12, height: 12, decoration: const BoxDecoration(color: Colors.amber, shape: BoxShape.circle)),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text('Buy Rate: ₹${goldRate.toStringAsFixed(0)}/gm', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(DateFormat('dd-Aug-2025').format(DateTime.now()), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            const SizedBox(height: 8),
                            const Text('Benefit: 5%', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const Divider(thickness: 1),

                  // Gradient Selection Area
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          lightPurple.withOpacity(0.1),
                          Colors.white,
                        ],
                      ),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'This transaction will earn you the following benefit',
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                        const SizedBox(height: 12),
                        // Benefit Bars
                        Row(
                          children: List.generate(5, (index) => Expanded(
                            child: Container(
                              height: 15,
                              margin: const EdgeInsets.symmetric(horizontal: 1),
                              decoration: BoxDecoration(
                                color: [
                                  Colors.green.shade800,
                                  Colors.green.shade600,
                                  Colors.green.shade400,
                                  Colors.green.shade300,
                                  Colors.green.shade100,
                                ][index],
                              ),
                            ),
                          )),
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'Start your gold savings journey',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        // Buy Option Radio
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildRadioOption('Buy in Rupees', isBuyInRupees, () => setState(() => isBuyInRupees = true)),
                            const SizedBox(width: 20),
                            _buildRadioOption('Buy in Grams', !isBuyInRupees, () => setState(() => isBuyInRupees = false)),
                          ],
                        ),
                        const SizedBox(height: 24),
                        // Input Field
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(isBuyInRupees ? '₹ ' : '', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                              Expanded(
                                child: TextField(
                                  controller: _amountController,
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    isDense: true,
                                  ),
                                  onChanged: (val) => setState(() {}),
                                ),
                              ),
                              Text(
                                isBuyInRupees 
                                  ? '${grams.toStringAsFixed(3)} gm' 
                                  : '₹ ${amount.toStringAsFixed(0)}',
                                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Quick Picks
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [100, 150, 200, 250, 300].map((val) => Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: ChoiceChip(
                                label: Text('₹$val'),
                                selected: isBuyInRupees && amount == val,
                                onSelected: (selected) {
                                  if (selected) {
                                    setState(() {
                                      isBuyInRupees = true;
                                      _amountController.text = val.toString();
                                    });
                                  }
                                },
                                selectedColor: primaryPurple,
                                labelStyle: TextStyle(
                                  color: (isBuyInRupees && amount == val) ? Colors.white : Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )).toList(),
                          ),
                        ),
                        
                        const SizedBox(height: 32),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text('You Get', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        ),
                        const SizedBox(height: 12),
                        // Total Value Box
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            border: Border.all(color: primaryPurple.withOpacity(0.5)),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('₹ ${totalValue.toStringAsFixed(0)}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                              Text('${totalGrams.toStringAsFixed(3)} gm', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Benefit: ₹${benefitAmount.toStringAsFixed(0)} (${(totalGrams - grams).toStringAsFixed(3)}g)',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom Button
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  // Update progress
                  final currentScheme = userNotifier.value.getScheme(widget.passbookID);
                  if (currentScheme != null) {
                    userNotifier.updateProgress(
                      widget.passbookID,
                      currentScheme.paidCount + 1,
                      currentScheme.totalWeight + totalGrams,
                    );
                  }
                  Navigator.pop(context, true);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: lightPurple,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('pay now', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRadioOption(String label, bool isSelected, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: isSelected ? const Color(0xFF410099) : Colors.grey, width: 2),
            ),
            child: isSelected 
              ? Center(child: Container(width: 8, height: 8, decoration: const BoxDecoration(color: Color(0xFF410099), shape: BoxShape.circle)))
              : null,
          ),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
