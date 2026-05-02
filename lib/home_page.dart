import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/gestures.dart';
import 'dart:io';
import 'dart:async';
import 'kyc_form_page.dart';
import 'passbook_page.dart';
import 'reward_page.dart';
import 'profile_page.dart';
import 'main.dart'; // Import for global languageNotifier

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Global Translations for HomePage
  static const Map<String, Map<String, String>> _localized = {
    'English': {
      'home': 'Home',
      'reward': 'Reward',
      'support': 'Support',
      'profile': 'Profile',
      'savings_title': 'Saving Schemes',
      'showroom_title': 'Showroom Location',
      'daily_rate': 'Daily Rate',
      'have_questions': 'Have Questions?',
      'get_in_touch': 'Get in touch with us.',
      'gold': 'Gold',
      'silver': 'Silver',
      'buy_now': 'Buy now',
      'explore': 'Explore',
      'visit_us': 'Visit us',
      'passbook_sub': 'Digital Passbook',
      'register_sub': 'Register & Start Savings',
      'active': 'ACTIVE',
    },
    'Tamil (தமிழ்)': {
      'home': 'முகப்பு',
      'reward': 'வெகுமதி',
      'support': 'ஆதரவு',
      'profile': 'சுயவிவரம்',
      'savings_title': 'சேமிப்பு திட்டங்கள்',
      'showroom_title': 'காட்சியறை இடம்',
      'daily_rate': 'தினசரி விலை',
      'have_questions': 'கேள்விகள் உள்ளதா?',
      'get_in_touch': 'எங்களைத் தொடர்பு கொள்ளுங்கள்.',
      'gold': 'தங்கம்',
      'silver': 'வெள்ளி',
      'buy_now': 'இப்போது வாங்கவும்',
      'explore': 'ஆராய்ந்து பாருங்கள்',
      'visit_us': 'எங்களை அணுகவும்',
      'passbook_sub': 'டிஜிட்டல் பாஸ்புக்',
      'register_sub': 'பதிவு செய்து சேமிக்கத் தொடங்குங்கள்',
      'active': 'செயலில் உள்ளது',
    }
  };

  String t(String key) {
    final langMap = _localized[languageNotifier.value];
    return langMap?[key] ?? key;
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
    );
  }

  PageController _pageController = PageController(viewportFraction: 0.85, initialPage: 1000);
  int _currentPage = 0;
  int _virtualPage = 1000;
  int _selectedNavIndex = 0;
  List<Map<String, dynamic>> _enrolledSchemes = []; // Stores {id, name, startDate}
  String _userName = ""; 
  Timer? _autoScrollTimer;
  bool _timerInitialized = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.88, initialPage: 1000);
    _pageController.addListener(() {
      if (mounted) setState(() {});
    });
    
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) _startAutoScroll();
    });
  }

  void _startAutoScroll() {
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (mounted && _pageController.hasClients) {
        _virtualPage++;
        _pageController.animateToPage(
          _virtualPage,
          duration: const Duration(milliseconds: 1500),
          curve: Curves.easeInOutCubic,
        );
      }
    });
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryPurple = Color(0xFF410099); // Exact deep purple from top
    const Color lightPurple = Color(0xFF6A1B9A); 
    const Color goldAccent = Color(0xFFFFC107);
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: IndexedStack(
        index: _selectedNavIndex,
        children: [
          _buildHomeBody(primaryPurple, lightPurple, goldAccent),
          const RewardPage(),
          const SizedBox(), // Support placeholder
          const ProfilePage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: primaryPurple,
        unselectedItemColor: Colors.grey.shade500,
        currentIndex: _selectedNavIndex,
        onTap: (index) => setState(() => _selectedNavIndex = index),
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
        unselectedLabelStyle: const TextStyle(fontSize: 11),
        items: [
          BottomNavigationBarItem(icon: const Icon(Icons.home), label: t('home')),
          BottomNavigationBarItem(icon: const Icon(Icons.emoji_events_outlined), label: t('reward')),
          BottomNavigationBarItem(icon: const Icon(Icons.support_agent_outlined), label: t('support')),
          BottomNavigationBarItem(icon: const Icon(Icons.person_outline), label: t('profile')),
        ],
      ),
    );
  }

  Widget _buildHomeBody(Color primaryPurple, Color lightPurple, Color goldAccent) {
    return Stack(
      children: [

          // 1. Extended Background Gradient (Handles Overscroll + Header)
          Positioned(
            top: -200, // Covers the area revealed during overscroll
            left: 0,
            right: 0,
            height: 400, // Covers App Bar and top of carousel only
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [0.0, 0.5, 0.7, 1.0], // Fade ends early
                  colors: [
                    primaryPurple,
                    primaryPurple, 
                    lightPurple.withOpacity(0.1),
                    Colors.white,
                  ],
                ),
              ),
            ),
          ),
          // 1. Scrolling Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 60), // Tightened gap
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                slivers: [
                  // Image Carousel
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 190,
                          child: ScrollConfiguration(
                            behavior: ScrollConfiguration.of(context).copyWith(
                              dragDevices: {
                                PointerDeviceKind.touch,
                                PointerDeviceKind.mouse,
                              },
                            ),
                            child: PageView.builder(
                              key: const ValueKey('carousel_main'),
                              controller: _pageController,
                              onPageChanged: (index) {
                                setState(() {
                                  _virtualPage = index;
                                  _currentPage = index % 5;
                                });
                              },
                              itemCount: 10000,
                              itemBuilder: (context, index) {
                                final int itemIndex = index % 5;
                                return AnimatedBuilder(
                                  animation: _pageController,
                                  builder: (context, child) {
                                    double scale = 0.82;
                                    double opacity = 0.5;
                                    double translation = 0.0;
                                    
                                    try {
                                      if (_pageController.hasClients) {
                                        double page = _pageController.page ?? 1000.0;
                                        double diff = (page - index).abs();
                                        scale = (1 - (diff * 0.18)).clamp(0.82, 1.0);
                                        opacity = (1 - (diff * 0.5)).clamp(0.5, 1.0);
                                        // Pull side images towards center to reduce gap
                                        translation = diff * 20.0;
                                      } else if (index == 1000) {
                                        scale = 1.0;
                                        opacity = 1.0;
                                      }
                                    } catch (_) {
                                      scale = (index == 1000) ? 1.0 : 0.82;
                                      opacity = (index == 1000) ? 1.0 : 0.5;
                                    }

                                    return Transform(
                                      transform: Matrix4.identity()
                                        ..scale(scale)
                                        ..translate(index > (_pageController.page ?? 1000) ? -translation : translation),
                                      alignment: Alignment.center,
                                      child: Opacity(
                                        opacity: opacity,
                                        child: child,
                                      ),
                                    );
                                  },
                                  child: Container(
                                    margin: EdgeInsets.zero,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF3C3C3C),
                                      borderRadius: BorderRadius.circular(16),
                                      image: DecorationImage(
                                        image: AssetImage(
                                          [
                                            'assets/images/Poster1.jpg',
                                            'assets/images/Poster2.jpg',
                                            'assets/images/Poster3.jpg',
                                            'assets/images/Poster4.jpg',
                                            'assets/images/Poster5.jpg',
                                          ][itemIndex],
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Carousel Dots
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(5, (index) {
                            bool isActive = _currentPage == index;
                            return Container(
                              margin: const EdgeInsets.symmetric(horizontal: 3),
                              height: 6,
                              width: isActive ? 16 : 6,
                              decoration: BoxDecoration(
                                color: isActive ? Colors.grey.shade600 : Colors.grey.shade400,
                                borderRadius: BorderRadius.circular(3),
                              ),
                            );
                          }),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),

                  // Sticky Rate Cards
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: _RateHeaderDelegate(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          children: [
                            // Gold Card
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFE599), // Light amber/yellow
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Text('₹9445 ', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900)),
                                        Text(t('gold'), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                        const Spacer(),
                                        Container(width: 12, height: 12, decoration: const BoxDecoration(color: Color(0xFFFFC107), shape: BoxShape.circle)),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    const Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('22KT Per gram', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500)),
                                        Text('₹25', style: TextStyle(fontSize: 11, color: Colors.red, fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    const Text('18-Aug-25 / 10:13 am', style: TextStyle(fontSize: 9, color: Colors.black54)),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            // Silver Card
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF0F0F0), // Light grey
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Text('₹127 ', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900)),
                                        Text(t('silver'), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                        const Spacer(),
                                        Container(width: 12, height: 12, decoration: const BoxDecoration(color: Color(0xFFBDBDBD), shape: BoxShape.circle)),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    const Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Per gram', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500)),
                                        Text('₹5', style: TextStyle(fontSize: 11, color: Color(0xFF00C853), fontWeight: FontWeight.bold)), // Green
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    const Text('18-Aug-25 / 10:13 am', style: TextStyle(fontSize: 9, color: Colors.black54)),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Remaining Content
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // My Passbook Section (Shows multiple cards if joined multiple times)
                        if (_enrolledSchemes.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          _buildSectionHeader(t('passbook_sub')),
                          const SizedBox(height: 12),
                          SizedBox(
                            height: 280, // Increased height for the detailed passbook card
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              itemCount: _enrolledSchemes.length,
                              itemBuilder: (context, index) {
                                final scheme = _enrolledSchemes[index];
                                return Container(
                                  width: MediaQuery.of(context).size.width * 0.95,
                                  margin: const EdgeInsets.only(right: 12),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        CupertinoPageRoute(
                                          builder: (context) => PassbookPage(
                                            userName: scheme['name'],
                                            passbookID: scheme['id'],
                                            startDate: scheme['startDate'],
                                          ),
                                        ),
                                      );
                                    },
                                    borderRadius: BorderRadius.circular(24),
                                    child: Container(
                                      constraints: const BoxConstraints(minHeight: 260),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(24),
                                          border: Border.all(color: const Color(0xFF410099).withOpacity(0.2), width: 1.5),
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
                                              // Top Purple Section with Mandala Pattern
                                              Container(
                                                height: 135,
                                                decoration: BoxDecoration(
                                                  color: const Color(0xFF410099).withOpacity(0.95),
                                                  image: const DecorationImage(
                                                    image: AssetImage('assets/images/4614.jpg'),
                                                    opacity: 0.15,
                                                    repeat: ImageRepeat.repeat,
                                                    fit: BoxFit.cover,
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
                                                        Text(scheme['name'], style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                                                        Text(scheme['id'], style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 11, letterSpacing: 1)),
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
                                                        const Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Text('₹2000', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900)),
                                                            Text('Per month', style: TextStyle(color: Colors.greenAccent, fontSize: 10, fontWeight: FontWeight.bold)),
                                                          ],
                                                        ),
                                                        const Text('2/11', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900)),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),

                                              // Content in White Section
                                              Padding(
                                                padding: const EdgeInsets.fromLTRB(16, 145, 16, 16),
                                                child: Column(
                                                  children: [
                                                    // Status Row (Now in White Section)
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            const Text('status: ', style: TextStyle(color: Colors.grey, fontSize: 14)),
                                                            Container(width: 10, height: 10, decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle)),
                                                            const SizedBox(width: 6),
                                                            Text(t('active'), style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
                                                          ],
                                                        ),
                                                        Container(
                                                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                                                          decoration: BoxDecoration(color: Colors.yellow[600], borderRadius: BorderRadius.circular(8)),
                                                          child: const Text('SAVE NOW', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12)),
                                                        ),
                                                      ],
                                                    ),
                                                    const Spacer(),
                                                    // Dates Row
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        _buildPassbookInfoColumn('Date of Joining', DateFormat('dd-MMM-yyyy').format(scheme['startDate'])),
                                                        _buildPassbookInfoColumn('Next Due Date', DateFormat('dd-MMM-yyyy').format(DateTime(scheme['startDate'].year, scheme['startDate'].month + 1, scheme['startDate'].day))),
                                                        _buildPassbookInfoColumn('Date of maturity', DateFormat('dd-MMM-yyyy').format(DateTime(scheme['startDate'].year, scheme['startDate'].month + 11, scheme['startDate'].day))),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 12),
                                                    // Progress Dots (Shrunken)
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: List.generate(11, (i) => Container(
                                                        margin: const EdgeInsets.symmetric(horizontal: 3),
                                                        width: 7, height: 7,
                                                        decoration: BoxDecoration(color: i < 2 ? Colors.green : Colors.grey[300], shape: BoxShape.circle),
                                                      )),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Positioned(
                                                top: 100, // Adjusted for new purple height
                                                left: 0, right: 0,
                                                child: Center(
                                                  child: Container(
                                                    width: 70, height: 70,
                                                    decoration: BoxDecoration(color: Colors.yellow[600], shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)),
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
                                },
                            ),
                          ),
                          const SizedBox(height: 12),
                        ],
                        
                        const SizedBox(height: 24),
                        // Welcome Banner
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF673AB7), Color(0xFF7E57C2)],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Welcome to the Ambal Jeweller !', style: TextStyle(color: Color(0xFFFFD54F), fontSize: 16, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 10),
                                const Text(
                                  'The ideal place to join a savings scheme and save up to buy your dream jewellery. Ambal DigiGold empowers you to save & buy jewellery conveniently in the palm of your hand. Start Saving in Gold today',
                                  style: TextStyle(color: Colors.white, fontSize: 12, height: 1.4),
                                ),
                                const SizedBox(height: 16),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFFD54F),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Text('KNOW MORE', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900)),
                                ),
                              ],
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Saving Scheme Heading
                        _buildSectionHeader(t('savings_title')),
                        const SizedBox(height: 12),
                        
                        // Single Saving Scheme Card
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Container(
                            height: 180,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: const Color(0xFF3C3C3C),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: Column(
                              children: [
                                Expanded(
                                  child: SizedBox.expand(
                                    child: Image.asset(
                                      'assets/images/Poster1.jpg',
                                      fit: BoxFit.cover,
                                      errorBuilder: (ctx, err, st) => Container(
                                        color: const Color(0xFF3C3C3C),
                                        child: const Center(
                                          child: Icon(Icons.image_outlined, color: Colors.white54, size: 48),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: InkWell(
                                        onTap: () async {
                                          final result = await Navigator.push(
                                            context,
                                            CupertinoPageRoute(builder: (context) => const KYCFormPage()),
                                          );
                                          if (result != null && result is Map) {
                                            setState(() {
                                              _userName = result['name'] ?? ""; // Set the user name for the header greeting
                                              _enrolledSchemes.add({
                                                'id': result['id'],
                                                'name': _userName,
                                                'startDate': DateTime.now(), // Joined today
                                              });
                                            });
                                          }
                                        },
                                        child: Container(
                                          color: const Color(0xFF673AB7),
                                          padding: const EdgeInsets.symmetric(vertical: 14),
                                          alignment: Alignment.center,
                                          child: const Text('JOIN NOW', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500)),
                                        ),
                                      ),
                                    ),
                                    Container(width: 1, color: Colors.white30, height: 42), // Divider
                                    Expanded(
                                      child: Container(
                                        color: const Color(0xFF512DA8),
                                        padding: const EdgeInsets.symmetric(vertical: 14),
                                        alignment: Alignment.center,
                                        child: const Text('KNOW MORE', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500)),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        
                        const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text(
                            '*Choose from a range of savings products with unique benefits to suit your needs and convenience',
                            style: TextStyle(fontSize: 12, color: Colors.black87, fontWeight: FontWeight.w500),
                          ),
                        ),
                        
                        const SizedBox(height: 8),
                        
                        // Our Showroom Section with Map
                        _buildSectionHeader(t('showroom_title')),
                        const SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Container(
                            height: 180,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: Stack(
                              children: [
                                // Realistic Map Visualization
                                Image.network(
                                  'https://images.unsplash.com/photo-1524661135-423995f22d0b?q=80&w=2000&auto=format&fit=crop', // Better stable map image
                                  width: double.infinity,
                                  height: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => Container(
                                    color: Colors.grey.shade200,
                                    child: const Center(child: Icon(Icons.map, color: Colors.grey, size: 48)),
                                  ),
                                ),
                                // Gradient Overlay for readability
                                Positioned.fill(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [Colors.transparent, Colors.black.withOpacity(0.6)],
                                      ),
                                    ),
                                  ),
                                ),
                                // Address Text
                                const Positioned(
                                  bottom: 12,
                                  left: 12,
                                  right: 12,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Ambal Jewellery, Dindigul', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                                      Text('99/1, Main Road, Begambur, Dindigul', style: TextStyle(color: Colors.white, fontSize: 11)),
                                    ],
                                  ),
                                ),
                                // Pin Icon
                                const Center(
                                  child: Icon(Icons.location_on, color: Colors.red, size: 40),
                                ),
                              ],
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Contact Banner
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                            decoration: BoxDecoration(
                              border: Border.all(color: const Color(0xFF512DA8), width: 1.5),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(t('have_questions'), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                    const SizedBox(height: 4),
                                    Text(t('get_in_touch'), style: const TextStyle(fontSize: 13, color: Colors.grey)),
                                  ],
                                ),
                                Icon(Icons.savings, color: Colors.red.shade300, size: 48), // Piggy bank equivalent
                              ],
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 30),
                                              ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 3. Locked App Bar Area
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              color: primaryPurple, // Reverted to solid color without shadow for cleaner transition
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Logo and Title
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 18,
                            backgroundColor: Colors.white.withOpacity(0.15),
                            child: ClipOval(
                              child: Image.asset(
                                'assets/images/AMBALLOGO-2.png',
                                width: 28,
                                height: 28,
                                fit: BoxFit.contain,
                                cacheWidth: 120,
                                cacheHeight: 120,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(Icons.broken_image, color: Colors.white, size: 16);
                                },
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Ambal Jewellery', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
                              Text('Dindigul', style: TextStyle(color: Colors.white, fontSize: 12)),
                            ],
                          ),
                        ],
                      ),
                      // Greeting and Notification
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text('hello👋', style: TextStyle(color: Colors.white, fontSize: 11)),
                              if (_userName.isNotEmpty)
                                Text(
                                  _userName.contains('!') ? _userName : '$_userName!', 
                                  style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                                ),
                            ],
                          ),
                          const SizedBox(width: 12),
                          Stack(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.15),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.notifications_none, color: Colors.white, size: 22),
                              ),
                              Positioned(
                                right: 8,
                                top: 8,
                                child: Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF00E676),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

        ],
      );
  }

  Widget _buildPassbookInfoColumn(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 9)),
        const SizedBox(height: 2),
        Text(value, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12)),
      ],
    );
  }
}

class _RateHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _RateHeaderDelegate({required this.child});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white, // Solid background when pinned
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: child,
    );
  }

  @override
  double get maxExtent => 115;

  @override
  double get minExtent => 115;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => false;
}
