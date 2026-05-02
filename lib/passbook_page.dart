import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PassbookPage extends StatefulWidget {
  final String userName;
  final String passbookID;
  final DateTime startDate;

  const PassbookPage({
    super.key,
    required this.userName,
    required this.passbookID,
    required this.startDate,
  });

  @override
  State<PassbookPage> createState() => _PassbookPageState();
}

class _PassbookPageState extends State<PassbookPage> {
  final Color primaryPurple = const Color(0xFF410099);
  final Color lightPurple = const Color(0xFF6A1B9A);
  final Color goldAccent = const Color(0xFFFFC107);
  
  int selectedMonthIndex = 0;
  String selectedTab = "RECIPTS";
  int paidCount = 2; // Track how many installments are paid
  bool isProcessingPayment = false;

  // Mock data for the 11-month logic
  late DateTime joiningDate;
  late DateTime maturityDate;
  late List<String> months;

  @override
  void initState() {
    super.initState();
    // Generate 11 months for the scheme and add 'all' at the start
    months = ['all'];
    for (int i = 0; i < 11; i++) {
      DateTime monthDate = DateTime(widget.startDate.year, widget.startDate.month + i);
      months.add(DateFormat('MMM').format(monthDate).toLowerCase());
    }
  }

  void _downloadPassbook(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(24),
            margin: const EdgeInsets.symmetric(horizontal: 40),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: primaryPurple.withOpacity(0.2), width: 1),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(color: Color(0xFF410099), strokeWidth: 3),
                const SizedBox(height: 20),
                Text(
                  'Generating Passbook PDF...',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: primaryPurple,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    // Simulate PDF generation delay
    Future.delayed(const Duration(seconds: 2), () {
      if (!context.mounted) return;
      Navigator.pop(context); // Close dialog
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 12),
              Expanded(
                child: Text('Passbook downloaded successfully!'),
              ),
            ],
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          margin: const EdgeInsets.all(16),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background Gradient
          Container(
            height: MediaQuery.of(context).size.height * 0.45,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  primaryPurple,
                  primaryPurple.withOpacity(0.8),
                  Colors.white,
                ],
              ),
            ),
          ),
          
          SafeArea(
            child: Column(
              children: [
                // 1. Custom Header (Fixed)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Expanded(
                        child: Text(
                          'scheme passbook',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.download_for_offline, color: Colors.white),
                        onPressed: () => _downloadPassbook(context),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.person_outline, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                
                // 2. Fixed Content (Summary, Month Selector, Tabs)
                _buildSummaryCard(),
                const SizedBox(height: 16),
                _buildMonthSelector(),
                const SizedBox(height: 16),
                _buildReceiptButton(),
                const SizedBox(height: 16),

                // 3. Scrollable Transaction History
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.only(bottom: 120), // Extra space for footer
                    child: _buildTransactionHistory(),
                  ),
                ),
              ],
            ),
          ),
          
          // Bottom Action Button
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildBottomActions(),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard() {
    bool isAll = selectedMonthIndex == 0;
    
    // Mock dynamic values
    String amount = isAll ? "₹21,340" : "₹1,940";
    String weight = isAll ? "2.061 g" : "0.187 g";
    String benefit = isAll ? "0.046 gram" : "0.004 gram";
    String rewards = isAll ? "0.022 gram" : "0.002 gram";

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: AspectRatio(
        aspectRatio: 1.5,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: primaryPurple.withOpacity(0.2), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Stack(
              children: [
                // Top Purple Section with User's Mandala Pattern
                Container(
                  height: 140,
                  decoration: BoxDecoration(
                    color: primaryPurple.withOpacity(0.95),
                    image: const DecorationImage(
                      image: AssetImage('assets/images/4614.jpg'),
                      opacity: 0.15,
                      repeat: ImageRepeat.repeat,
                      fit: BoxFit.cover, // Better for high-quality mandala assets
                    ),
                  ),
                ),
                
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // Header Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.userName,
                            style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            widget.passbookID,
                            style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 11, letterSpacing: 1),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Labels Row
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('SCHEME AMOUNT', style: TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.w900)),
                          Text('INSTALLMENT\'S PAID', style: TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.w900)),
                        ],
                      ),
                      
                      // Values Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                           Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              const Text('₹2000', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900)),
                              const SizedBox(width: 4),
                              Text('Per month', style: TextStyle(color: Colors.greenAccent[400], fontSize: 10, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          Text('$paidCount/11', style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900)),
                        ],
                      ),
                      
                      const SizedBox(height: 12),
                      
                      // Status and Save Now Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Text('status: ', style: TextStyle(color: Colors.white70, fontSize: 14)),
                              Container(
                                width: 10,
                                height: 10,
                                decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle),
                              ),
                              const SizedBox(width: 6),
                              const Text('ACTIVE', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          InkWell(
                            onTap: () {
                              if (paidCount < 11) {
                                setState(() => selectedMonthIndex = paidCount + 1);
                              }
                            },
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.yellow[600],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text('SAVE NOW', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12)),
                            ),
                          ),
                        ],
                      ),
                      
                      const Spacer(),
                      
                      // Bottom Info Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildInfoColumn('Date of Joining', DateFormat('dd-MMM-yyyy').format(widget.startDate)),
                          Container(width: 1, height: 40, color: Colors.grey[300]),
                          _buildInfoColumn('Next Due Date', DateFormat('dd-MMM-yyyy').format(DateTime(widget.startDate.year, widget.startDate.month + paidCount, widget.startDate.day))),
                          Container(width: 1, height: 40, color: Colors.grey[300]),
                          _buildInfoColumn('Date of maturity', DateFormat('dd-MMM-yyyy').format(DateTime(widget.startDate.year, widget.startDate.month + 11, widget.startDate.day))),
                        ],
                      ),
                      
                      const SizedBox(height: 12),
                      
                      // Simplified Small Progress Dots (Non-interactive)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(11, (index) {
                          bool isPaid = index < paidCount; 
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            width: 7,
                            height: 7,
                            decoration: BoxDecoration(
                              color: isPaid ? Colors.green : Colors.grey[300],
                              shape: BoxShape.circle,
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),

                // Central Yellow Badge
                Positioned(
                  top: 105,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        color: Colors.yellow[600],
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('TOTAL', style: TextStyle(fontSize: 6, fontWeight: FontWeight.bold)),
                          Text('WEIGHT SAVED', style: TextStyle(fontSize: 6, fontWeight: FontWeight.bold)),
                          SizedBox(height: 2),
                          Text('2.061 g', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoColumn(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 9)),
        const SizedBox(height: 2),
        Text(value, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12)),
      ],
    );
  }

  Widget _buildMonthSelector() {
    int nextDueIndex = paidCount + 1;
    
    return SizedBox(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: months.length,
        itemBuilder: (context, index) {
          bool isSelected = selectedMonthIndex == index;
          bool isPaid = index > 0 && index <= paidCount;
          bool isNextDue = index == nextDueIndex;
          String label = months[index].toUpperCase();
          
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            child: InkWell(
              onTap: () => setState(() => selectedMonthIndex = index),
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              hoverColor: Colors.transparent,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: isSelected ? primaryPurple : (isPaid ? Colors.green.withOpacity(0.1) : Colors.white),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected 
                      ? primaryPurple 
                      : (isNextDue ? Colors.orange : Colors.grey.shade300),
                    width: isNextDue || isSelected ? 2.0 : 1.2,
                  ),
                ),
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        color: isSelected ? Colors.white : (isPaid ? Colors.green : Colors.black87),
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                    if (isPaid && !isSelected)
                      const Icon(Icons.check, color: Colors.green, size: 8),
                    if (isNextDue && !isSelected)
                      Container(
                        width: 4,
                        height: 4,
                        decoration: const BoxDecoration(color: Colors.orange, shape: BoxShape.circle),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildReceiptButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        width: double.infinity,
        height: 48,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: primaryPurple, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: primaryPurple.withOpacity(0.15),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: const Text(
          'RECEIPT',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 14,
            letterSpacing: 1.5,
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionHistory() {
    bool isAll = selectedMonthIndex == 0;
    String monthHeader = isAll ? "Transaction history" : "${DateFormat('MMMM yyyy').format(DateTime(widget.startDate.year, widget.startDate.month + selectedMonthIndex - 1))} Transactions";

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                monthHeader,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              if (!isAll)
                TextButton(
                  onPressed: () => setState(() => selectedMonthIndex = 0),
                  child: const Text('view all', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                ),
            ],
          ),
          const SizedBox(height: 12),
          
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                const SizedBox(width: 40, child: Text('Status', style: TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.w500))),
                const SizedBox(width: 80, child: Text('Date', style: TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.w500))),
                const Expanded(child: SizedBox()), // Space for middle status text
                const Text('Amount', style: TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          const SizedBox(height: 8),
          
          // List Items (Logic matching the pic)
          if (isAll) ...[
            ...List.generate(11, (i) {
              DateTime dueDate = DateTime(widget.startDate.year, widget.startDate.month + i, widget.startDate.day);
              String dateStr = DateFormat('dd.MM.yy').format(dueDate);
              
              if (i < paidCount) {
                // If i == 1 (Feb), let's simulate 'Paid late' like the pic
                String status = (i == 1) ? "Paid late" : "Completed";
                Color statusColor = (i == 1) ? Colors.red.shade400 : Colors.green.shade600;
                // Add a small delay for the late date
                if (i == 1) dateStr = DateFormat('dd.MM.yy').format(dueDate.add(const Duration(days: 3)));
                
                return _buildTransactionItem(
                  status: status,
                  date: dateStr,
                  amount: "₹2000",
                  statusColor: statusColor,
                  icon: Icons.check_circle_outline,
                  monthIndex: i,
                );
              } else if (i == paidCount) {
                // Next due month
                return _buildTransactionItem(
                  status: "Overdue",
                  date: dateStr,
                  amount: "₹2000",
                  statusColor: Colors.red,
                  icon: Icons.radio_button_unchecked,
                  isOverdue: true,
                  monthIndex: i,
                );
              } else {
                // Future months
                return _buildTransactionItem(
                  status: "",
                  date: dateStr,
                  amount: "₹2000",
                  statusColor: Colors.grey,
                  icon: Icons.radio_button_unchecked,
                  monthIndex: i,
                );
              }
            }),
          ] else ...[
            // Monthly View logic
            _buildMonthlyViewItem(selectedMonthIndex - 1),
          ],
        ],
      ),
    );
  }

  Widget _buildMonthlyViewItem(int i) {
    DateTime dueDate = DateTime(widget.startDate.year, widget.startDate.month + i, widget.startDate.day);
    String dateStr = DateFormat('dd.MM.yy').format(dueDate);
    
    if (i < paidCount) {
      String status = (i == 1) ? "Paid late" : "Completed";
      Color statusColor = (i == 1) ? Colors.red.shade400 : Colors.green.shade600;
      if (i == 1) dateStr = DateFormat('dd.MM.yy').format(dueDate.add(const Duration(days: 3)));
      return _buildTransactionItem(status: status, date: dateStr, amount: "₹2000", statusColor: statusColor, icon: Icons.check_circle_outline, monthIndex: i);
    } else if (i == paidCount) {
      return _buildTransactionItem(status: "Overdue", date: dateStr, amount: "₹2000", statusColor: Colors.red, icon: Icons.radio_button_unchecked, isOverdue: true, monthIndex: i);
    } else {
      return _buildTransactionItem(status: "", date: dateStr, amount: "₹2000", statusColor: Colors.grey, icon: Icons.radio_button_unchecked, monthIndex: i);
    }
  }

  Widget _buildTransactionItem({
    required String status,
    required String date,
    required String amount,
    required Color statusColor,
    required IconData icon,
    bool isOverdue = false,
    int? monthIndex,
  }) {
    bool isSelected = monthIndex != null && selectedMonthIndex == monthIndex + 1;

    return InkWell(
      onTap: monthIndex != null ? () => setState(() => selectedMonthIndex = monthIndex + 1) : null,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? primaryPurple.withOpacity(0.05) : Colors.white,
          border: Border.all(
            color: isSelected 
              ? primaryPurple 
              : (isOverdue ? Colors.red.withOpacity(0.5) : const Color(0xFF410099).withOpacity(0.3)), 
            width: isSelected ? 2.0 : 1.5
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? primaryPurple : statusColor, size: 28),
            const SizedBox(width: 12),
            SizedBox(
              width: 80,
              child: Text(
                date,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, letterSpacing: 0.5),
              ),
            ),
            const Expanded(child: SizedBox()),
            if (status.isNotEmpty)
              Text(
                status,
                style: TextStyle(color: isSelected ? primaryPurple : statusColor, fontWeight: FontWeight.bold, fontSize: 13),
              ),
            const Expanded(child: SizedBox()),
            Text(
              amount,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomActions() {
    int targetIndex = selectedMonthIndex == 0 ? paidCount + 1 : selectedMonthIndex;
    bool isAlreadyPaid = targetIndex <= paidCount;
    bool isNextAvailable = targetIndex == paidCount + 1;
    bool isFuture = targetIndex > paidCount + 1;
    bool isSchemeCompleted = paidCount >= 11;

    String buttonText = "pay now";
    if (isSchemeCompleted) {
      buttonText = "scheme completed";
    } else if (isAlreadyPaid) {
      buttonText = "already paid";
    } else if (isFuture) {
      buttonText = "pay previous first";
    } else if (selectedMonthIndex > 0) {
      buttonText = "pay ${months[selectedMonthIndex].toUpperCase()} now";
    }

    return SafeArea(
      bottom: true,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5)),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: (isProcessingPayment || isAlreadyPaid || isFuture || isSchemeCompleted) 
                  ? null 
                  : () => _processPayment(targetIndex),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryPurple,
                  disabledBackgroundColor: Colors.grey.shade300,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: isProcessingPayment
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    )
                  : Text(
                      buttonText, 
                      style: TextStyle(
                        color: (isAlreadyPaid || isFuture || isSchemeCompleted) ? Colors.grey : Colors.white, 
                        fontSize: 16, 
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      )
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _processPayment(int targetIndex) {
    setState(() => isProcessingPayment = true);
    
    // Simulate payment process
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      
      setState(() {
        isProcessingPayment = false;
        paidCount++;
        // If we paid the selected month, we could either stay or move to next
        // But the user said "after do another select", so let's keep current selection 
        // which now will show as "Already Paid".
      });

      _showSuccessDialog(targetIndex);
    });
  }

  void _showSuccessDialog(int targetIndex) {
    String monthName = months[targetIndex].toUpperCase();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 60),
            const SizedBox(height: 16),
            const Text(
              'Payment Successful!',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              'Transaction for $monthName installment completed successfully.',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryPurple,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Continue', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

