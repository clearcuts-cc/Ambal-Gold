import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:google_fonts/google_fonts.dart';

class RealNotificationService {
  static final AudioPlayer _audioPlayer = AudioPlayer();
  static OverlayEntry? _overlayEntry;
  static Timer? _dismissTimer;

  static void showRealNotification({
    required BuildContext context,
    required String title,
    required String message,
    VoidCallback? onTap,
  }) async {
    // 1. Play Sound
    try {
      await _audioPlayer.play(UrlSource('https://assets.mixkit.co/active_storage/sfx/2358/2358-preview.mp3'));
    } catch (e) {
      debugPrint('Error playing notification sound: $e');
    }

    // 2. Remove previous if exists
    _overlayEntry?.remove();
    _dismissTimer?.cancel();

    // 3. Create Overlay Entry
    _overlayEntry = OverlayEntry(
      builder: (context) => _NotificationPopup(
        title: title,
        message: message,
        onTap: () {
          _overlayEntry?.remove();
          _overlayEntry = null;
          _dismissTimer?.cancel();
          onTap?.call();
        },
        onDismiss: () {
          _overlayEntry?.remove();
          _overlayEntry = null;
        },
      ),
    );

    // 4. Insert Overlay
    Overlay.of(context).insert(_overlayEntry!);

    // 5. Auto dismiss after 5 seconds
    _dismissTimer = Timer(const Duration(seconds: 5), () {
      if (_overlayEntry != null) {
        _overlayEntry?.remove();
        _overlayEntry = null;
      }
    });
  }
}

class _NotificationPopup extends StatefulWidget {
  final String title;
  final String message;
  final VoidCallback onTap;
  final VoidCallback onDismiss;

  const _NotificationPopup({
    required this.title,
    required this.message,
    required this.onTap,
    required this.onDismiss,
  });

  @override
  State<_NotificationPopup> createState() => _NotificationPopupState();
}

class _NotificationPopupState extends State<_NotificationPopup> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0, -1.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Align(
          alignment: Alignment.topCenter,
          child: SlideTransition(
            position: _offsetAnimation,
            child: Material(
              color: Colors.transparent,
              child: GestureDetector(
                onTap: widget.onTap,
                onVerticalDragUpdate: (details) {
                  if (details.primaryDelta! < -10) {
                    _controller.reverse().then((_) => widget.onDismiss());
                  }
                },
                child: Container(
                  width: double.infinity,
                  constraints: const BoxConstraints(minHeight: 80, maxHeight: 100),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.95),
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                    border: Border.all(color: Colors.white.withOpacity(0.5), width: 1),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(22),
                    child: Stack(
                      children: [
                        // Glassmorphism effect if desired
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              // App Icon
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF410099),
                                  borderRadius: BorderRadius.circular(10),
                                  image: const DecorationImage(
                                    image: AssetImage('assets/images/AMBALLOGO-2.png'),
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              // Content
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'AMBAL GOLD',
                                          style: GoogleFonts.outfit(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w900,
                                            color: const Color(0xFF410099),
                                            letterSpacing: 1.2,
                                          ),
                                        ),
                                        Text(
                                          'now',
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.grey.shade500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      widget.title,
                                      style: GoogleFonts.outfit(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      widget.message,
                                      style: GoogleFonts.outfit(
                                        fontSize: 12,
                                        color: Colors.grey.shade700,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Handle
                        Positioned(
                          bottom: 4,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: Container(
                              width: 36,
                              height: 3,
                              decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
