import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:veeras_beauty/core/theme.dart';
import 'package:veeras_beauty/core/constants.dart';
import 'package:veeras_beauty/shared/widgets/gradient_button.dart';

class BookingConfirmScreen extends ConsumerStatefulWidget {
  final String bookingId;
  const BookingConfirmScreen({super.key, required this.bookingId});

  @override
  ConsumerState<BookingConfirmScreen> createState() => _BookingConfirmScreenState();
}

class _BookingConfirmScreenState extends ConsumerState<BookingConfirmScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  late final Animation<double> _scaleAnim;
  Map<String, dynamic>? _booking;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _scaleAnim = CurvedAnimation(parent: _animController, curve: Curves.elasticOut);
    _animController.forward();
    _loadBooking();
  }

  Future<void> _loadBooking() async {
    // We rely on the data returned from the create API; in production fetch by ID
    // For simplicity, we just show a success screen
    setState(() => _booking = {'_id': widget.bookingId});
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Future<void> _openWhatsApp(String message) async {
    final url = Uri.parse('https://wa.me/${AppConstants.whatsappNumber}?text=${Uri.encodeComponent(message)}');
    if (await canLaunchUrl(url)) await launchUrl(url, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Success Animation
                ScaleTransition(
                  scale: _scaleAnim,
                  child: Container(
                    width: 120, height: 120,
                    decoration: BoxDecoration(
                      gradient: AppTheme.primaryGradient,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(color: AppTheme.primary.withOpacity(0.4), blurRadius: 30, spreadRadius: 5),
                      ],
                    ),
                    child: const Icon(Icons.check, color: Colors.white, size: 60),
                  ),
                ),
                const SizedBox(height: 32),
                Text('Booking Confirmed!', style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: AppTheme.textPrimary,
                )),
                const SizedBox(height: 12),
                Text(
                  'Your appointment has been successfully booked. We will confirm via WhatsApp.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 32),

                // Payment note
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.warning.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppTheme.warning.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.payment, color: AppTheme.warning),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Payment at Parlour', style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: AppTheme.warning,
                            )),
                            Text('You can pay via Cash or GPay when you arrive.',
                              style: Theme.of(context).textTheme.bodySmall),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // WhatsApp CTA
                GradientButton(
                  label: 'Confirm on WhatsApp',
                  icon: Icons.chat_rounded,
                  color: const Color(0xFF25D366),
                  onPressed: () => _openWhatsApp(
                    'Hi! I just booked a service at Veera\'s Beauty & Tattoo Studio. Booking ID: ${widget.bookingId}. Please confirm my appointment.',
                  ),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () => context.go('/'),
                  icon: const Icon(Icons.home_outlined),
                  label: const Text('Back to Home'),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () => context.push('/my-bookings'),
                  child: const Text('View My Bookings'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
