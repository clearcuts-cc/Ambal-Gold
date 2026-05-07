import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final List<Map<String, dynamic>> _notifications = [
    {
      'id': '1',
      'title': 'Gold Rate Alert! 📈',
      'message': 'Gold prices dropped by ₹25 today. This is a great time to invest in your savings scheme!',
      'time': DateTime.now().subtract(const Duration(minutes: 15)),
      'isRead': false,
      'type': 'offer',
    },
    {
      'id': '2',
      'title': 'Payment Successful ✅',
      'message': 'Your monthly installment of ₹2,000 for "Ambal Gold Scheme" has been successfully received.',
      'time': DateTime.now().subtract(const Duration(hours: 2)),
      'isRead': false,
      'type': 'transaction',
    },
    {
      'id': '3',
      'title': 'Welcome to Ambal Gold! ✨',
      'message': 'Start your journey towards owning beautiful jewelry by joining our flexible savings plans.',
      'time': DateTime.now().subtract(const Duration(days: 1)),
      'isRead': true,
      'type': 'info',
    },
    {
      'id': '4',
      'title': 'New Collection Launch 💎',
      'message': 'Explore our latest "Divine Heritage" collection now available at our Dindigul showroom.',
      'time': DateTime.now().subtract(const Duration(days: 2)),
      'isRead': true,
      'type': 'offer',
    },
  ];

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
          'Notifications',
          style: GoogleFonts.outfit(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                for (var n in _notifications) {
                  n['isRead'] = true;
                }
              });
            },
            child: const Text(
              'Read all',
              style: TextStyle(color: primaryPurple, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: _notifications.isEmpty
          ? _buildEmptyState()
          : ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 16),
              itemCount: _notifications.length,
              separatorBuilder: (context, index) => const SizedBox(height: 1),
              itemBuilder: (context, index) {
                final notification = _notifications[index];
                return _buildNotificationItem(notification);
              },
            ),
    );
  }

  Widget _buildNotificationItem(Map<String, dynamic> notification) {
    final bool isRead = notification['isRead'];
    final String type = notification['type'];
    
    IconData icon;
    Color iconColor;
    Color bgColor;

    switch (type) {
      case 'offer':
        icon = Icons.local_offer_outlined;
        iconColor = Colors.orange;
        bgColor = Colors.orange.withOpacity(0.1);
        break;
      case 'transaction':
        icon = Icons.account_balance_wallet_outlined;
        iconColor = Colors.green;
        bgColor = Colors.green.withOpacity(0.1);
        break;
      default:
        icon = Icons.notifications_outlined;
        iconColor = const Color(0xFF410099);
        bgColor = const Color(0xFF410099).withOpacity(0.1);
    }

    return InkWell(
      onTap: () {
        setState(() {
          notification['isRead'] = true;
        });
        _showNotificationDetail(notification);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isRead ? Colors.transparent : Colors.white,
          border: Border(
            bottom: BorderSide(color: Colors.grey.withOpacity(0.1)),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: bgColor,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(width: 16),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        notification['title'],
                        style: GoogleFonts.outfit(
                          fontWeight: isRead ? FontWeight.w500 : FontWeight.bold,
                          fontSize: 15,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        _formatTime(notification['time']),
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    notification['message'],
                    style: GoogleFonts.outfit(
                      color: Colors.grey.shade700,
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            if (!isRead)
              Container(
                margin: const EdgeInsets.only(left: 8, top: 4),
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Color(0xFF410099),
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications_off_outlined, size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            'No notifications yet',
            style: GoogleFonts.outfit(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'We\'ll notify you when something important happens.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return DateFormat('dd MMM').format(time);
    }
  }

  void _showNotificationDetail(Map<String, dynamic> notification) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Text(
                  notification['title'],
                  style: GoogleFonts.outfit(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Text(
                  _formatTime(notification['time']),
                  style: TextStyle(color: Colors.grey[500], fontSize: 13),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              notification['message'],
              style: GoogleFonts.outfit(
                fontSize: 16,
                height: 1.6,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF410099),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleProxy(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text('Dismiss', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class RoundedRectangleProxy extends RoundedRectangleBorder {
  const RoundedRectangleProxy({super.borderRadius});
}
