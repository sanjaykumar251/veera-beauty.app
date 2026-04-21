import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:veeras_beauty/core/constants.dart';
import 'package:veeras_beauty/core/theme.dart';
import 'package:veeras_beauty/features/auth/providers/auth_provider.dart';
import 'package:veeras_beauty/shared/widgets/gradient_button.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final userAsync = ref.watch(currentUserProvider);
    final user = userAsync.valueOrNull;
    final isLoggedIn = authState.value != null;
    final isVIP = ref.read(currentUserProvider.notifier).isVIP;

    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              height: 340,
              decoration: const BoxDecoration(gradient: AppTheme.heroGradient),
              child: Stack(
                children: [
                  Positioned(
                    top: -40,
                    right: -40,
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppTheme.primary.withOpacity(0.08),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -20,
                    left: -30,
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppTheme.accent.withOpacity(0.06),
                      ),
                    ),
                  ),
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      isLoggedIn
                                          ? 'Welcome back,'
                                          : 'Welcome to',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    ),
                                    Text(
                                      isLoggedIn
                                          ? (user?['name'] ?? 'Guest')
                                          : "Veera's Beauty",
                                      style: Theme.of(context)
                                          .textTheme
                                          .displaySmall
                                          ?.copyWith(
                                            color: AppTheme.textPrimary,
                                          ),
                                    ),
                                    Text(
                                      '& Tattoo Studio',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium
                                          ?.copyWith(
                                            color: AppTheme.textPrimary,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              if (isVIP)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    gradient: AppTheme.goldGradient,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.workspace_premium,
                                          color: Colors.white, size: 14),
                                      const SizedBox(width: 4),
                                      Text(
                                        'VIP',
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelMedium
                                            ?.copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              if (!isLoggedIn)
                                TextButton(
                                  onPressed: () => context.push('/login'),
                                  child: const Text('Login'),
                                ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            AppConstants.businessTagline,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 24),
                          Row(
                            children: [
                              Expanded(
                                child: GradientButton(
                                  label: 'Book Service',
                                  icon: Icons.calendar_today,
                                  onPressed: () => context.push('/services'),
                                ),
                              ),
                              const SizedBox(width: 12),
                              _ContactButton(
                                icon: Icons.chat_rounded,
                                label: 'WhatsApp',
                                color: const Color(0xFF25D366),
                                onPressed: () => _openWhatsApp(),
                              ),
                              const SizedBox(width: 8),
                              _ContactButton(
                                icon: Icons.call_rounded,
                                label: 'Call',
                                color: AppTheme.info,
                                onPressed: () => _makeCall(),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
              child: Text('Our Services',
                  style: Theme.of(context).textTheme.headlineMedium),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 110,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                children: AppConstants.categoryLabels.entries.map((entry) {
                  return GestureDetector(
                    onTap: () =>
                        context.push('/services?category=${entry.key}'),
                    child: Container(
                      width: 82,
                      margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        color: AppTheme.cardDark,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFF2A2A3A)),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AppConstants.categoryIcons[entry.key] ?? '*',
                            style: const TextStyle(fontSize: 28),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            entry.value,
                            style: Theme.of(context).textTheme.labelSmall,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: const [
                  _StudioTag(label: 'Organic mehendi cone for sale'),
                  _StudioTag(label: 'Mehendi service available'),
                  _StudioTag(label: 'Bridal bookings with special offers'),
                ],
              ),
            ),
          ),
          if (!isVIP)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                child: GestureDetector(
                  onTap: () => context.push('/membership'),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: AppTheme.goldGradient,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.workspace_premium,
                            color: Colors.white, size: 40),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'VIP Loyalty Membership',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall
                                    ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              Text(
                                'Yearly package • 11th free • Buy 1 Get 1',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(color: Colors.white70),
                              ),
                              Text(
                                'Bridal bookings get extra 5% offer',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelMedium
                                    ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.arrow_forward_ios,
                            color: Colors.white, size: 18),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
              child: GestureDetector(
                onTap: () => context.push('/academy'),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: AppTheme.primaryGradient,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.school_rounded,
                          color: Colors.white, size: 40),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Veera's Academy",
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            Text(
                              'Bridal makeup, beautician, hair, tattoo and more',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(color: Colors.white70),
                            ),
                            Text(
                              'Professional classes available now',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium
                                  ?.copyWith(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
              child: Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5EFE8),
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Veera's Beauty & Tattoo",
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                color: const Color(0xFF1E1713),
                              ),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '4.9',
                          style: Theme.of(context)
                              .textTheme
                              .displayLarge
                              ?.copyWith(
                                color: const Color(0xFF1E1713),
                                fontSize: 68,
                              ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: List.generate(
                                    5,
                                    (_) => const Padding(
                                      padding: EdgeInsets.only(right: 2),
                                      child: Icon(Icons.star_rounded,
                                          color: Color(0xFFD4AF37), size: 24),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Based on 85+ Google Reviews',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                        color: const Color(0xFF51453D),
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Text(
                      "Cheyyar's most trusted beauty studio, loved by brides, families and everyday clients alike.",
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: const Color(0xFF3A302B),
                                height: 1.35,
                              ),
                    ),
                    const SizedBox(height: 22),
                    const _TestimonialCard(
                      review:
                          'She did an excellent job with both makeup and hairstyling. It looked natural and elegant, and the makeup lasted for hours.',
                      name: 'Priya R.',
                      service: "Sister's Engagement Makeup",
                    ),
                    const SizedBox(height: 14),
                    const _TestimonialCard(
                      review:
                          'Bridal booking experience was smooth from start to finish. Mehendi, saree draping and makeup all came out beautifully.',
                      name: 'Keerthana S.',
                      service: 'Bridal Combo Booking',
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.cardDark,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF2A2A3A)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.location_on,
                        color: AppTheme.primary, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Find Us',
                              style: Theme.of(context).textTheme.titleMedium),
                          const SizedBox(height: 4),
                          Text(AppConstants.address,
                              style: Theme.of(context).textTheme.bodySmall),
                          const SizedBox(height: 8),
                          Text(
                            'Phone: ${AppConstants.phoneNumber}',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: AppTheme.primary),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Future<void> _openWhatsApp() async {
    final url = Uri.parse(
      'https://wa.me/${AppConstants.whatsappNumber}?text=Hi%2C%20I%20want%20to%20book%20a%20service.',
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  static Future<void> _makeCall() async {
    final url = Uri.parse('tel:${AppConstants.phoneNumber}');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }
}

class _ContactButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onPressed;

  const _ContactButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Icon(icon, color: color, size: 22),
      ),
    );
  }
}

class _StudioTag extends StatelessWidget {
  final String label;

  const _StudioTag({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF2A2A3A)),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium,
      ),
    );
  }
}

class _TestimonialCard extends StatelessWidget {
  final String review;
  final String name;
  final String service;

  const _TestimonialCard({
    required this.review,
    required this.name,
    required this.service,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.format_quote_rounded,
              color: Color(0xFFE4C8D1), size: 32),
          const SizedBox(height: 6),
          Row(
            children: List.generate(
              5,
              (_) => const Padding(
                padding: EdgeInsets.only(right: 2),
                child: Icon(Icons.star_rounded,
                    color: Color(0xFFD4AF37), size: 18),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            review,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: const Color(0xFF3B302C),
                  height: 1.5,
                ),
          ),
          const SizedBox(height: 18),
          Text(
            name,
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(color: const Color(0xFF231A17)),
          ),
          const SizedBox(height: 2),
          Text(
            service,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: const Color(0xFFB46F8B)),
          ),
        ],
      ),
    );
  }
}
