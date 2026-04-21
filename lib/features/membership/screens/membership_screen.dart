import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:veeras_beauty/core/theme.dart';
import 'package:veeras_beauty/features/auth/providers/auth_provider.dart';
import 'package:veeras_beauty/shared/services/api_service.dart';
import 'package:veeras_beauty/shared/widgets/gradient_button.dart';

class MembershipScreen extends ConsumerStatefulWidget {
  const MembershipScreen({super.key});

  @override
  ConsumerState<MembershipScreen> createState() => _MembershipScreenState();
}

class _MembershipScreenState extends ConsumerState<MembershipScreen> {
  Map<String, dynamic>? _plan;
  Map<String, dynamic>? _membership;
  String? _qrDataUrl;
  bool _showQR = false;
  bool _loading = true;
  bool _qrLoading = false;
  bool _offlineMode = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final isLoggedIn = ref.read(authStateProvider).value != null;
    Map<String, dynamic>? planData;
    Map<String, dynamic>? memberData;

    try {
      planData = await ref.read(apiServiceProvider).getVIPPlan();
    } catch (_) {}

    if (isLoggedIn) {
      try {
        memberData = await ref.read(apiServiceProvider).getMyMembership();
      } catch (_) {}
    }

    if (!mounted) return;

    setState(() {
      _plan = planData?['plan'];
      _membership = memberData?['membership'];
      _offlineMode = planData?['offlineMode'] == true;
      _loading = false;
    });
  }

  int get _vipPrice {
    final rawPrice = _plan?['price'];
    if (rawPrice is int) return rawPrice;
    if (rawPrice is num) return rawPrice.round();
    return 999;
  }

  Future<void> _showPaymentQR() async {
    setState(() {
      _showQR = true;
      _qrLoading = true;
      _qrDataUrl = null;
    });

    try {
      final data = await ref.read(apiServiceProvider).getPaymentQR(
            amount: _vipPrice,
            note: 'VIP Membership',
          );
      if (!mounted) return;
      setState(() {
        _qrDataUrl = data['qrDataUrl'];
        _qrLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _qrLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to load payment QR right now.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final isVIP = _membership?['isVIP'] == true;
    final totalBookings = _membership?['totalBookings'] ?? 0;
    final nextFree = _membership?['nextFreeBookingAt'] ?? 11;
    final bookingsLeft =
        nextFree > totalBookings ? nextFree - totalBookings : 0;

    return Scaffold(
      appBar: AppBar(title: const Text('VIP Membership')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_offlineMode)
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppTheme.info.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppTheme.info.withOpacity(0.35)),
                ),
                child: const Text(
                  'Showing saved VIP details. QR payment and activation need the studio server to be online.',
                ),
              ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: isVIP ? AppTheme.goldGradient : AppTheme.darkGradient,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: isVIP
                      ? AppTheme.accent
                      : AppTheme.primary.withOpacity(0.3),
                  width: isVIP ? 2 : 1,
                ),
              ),
              child: Column(
                children: [
                  const Icon(Icons.workspace_premium,
                      size: 64, color: Colors.white),
                  const SizedBox(height: 12),
                  Text(
                    isVIP ? 'You are a VIP Member' : 'Become a VIP Member',
                    style: Theme.of(context)
                        .textTheme
                        .displaySmall
                        ?.copyWith(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isVIP
                        ? 'Your loyalty perks are active now.'
                        : 'Yearly package for regular clients with better offers.',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: Colors.white70),
                    textAlign: TextAlign.center,
                  ),
                  if (isVIP && _membership?['expiry'] != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      'Valid until: ${_formatDate(_membership!['expiry'])}',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: Colors.white70),
                    ),
                  ] else ...[
                    const SizedBox(height: 12),
                    Text(
                      'Only Rs $_vipPrice / year',
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                  ],
                ],
              ),
            ),
            if (isVIP) ...[
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppTheme.cardDark,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFF2A2A3A)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Your VIP Progress',
                        style: Theme.of(context).textTheme.headlineMedium),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Visits: $totalBookings',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        Text(
                          bookingsLeft == 0
                              ? 'Free service unlocked!'
                              : '$bookingsLeft more for FREE service',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: AppTheme.accent),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: (totalBookings % 11) / 11,
                        backgroundColor: const Color(0xFF2A2A3A),
                        valueColor:
                            const AlwaysStoppedAnimation(AppTheme.accent),
                        minHeight: 10,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Every 11th service is free for VIP clients.',
                      style: Theme.of(context)
                          .textTheme
                          .labelMedium
                          ?.copyWith(color: AppTheme.accent),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 24),
            Text('VIP Benefits',
                style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 12),
            ...const [
              (
                'Yearly loyalty package',
                'One year membership with special offers for regular clients',
              ),
              (
                'Buy 1 Get 1 offers',
                'Selected combo deals during studio offer periods',
              ),
              (
                '11th service free',
                'Take 10 services and unlock the 11th service free',
              ),
              (
                '5% extra bridal offer',
                'VIP brides get extra savings on bridal bookings',
              ),
              (
                'Priority slots',
                'Weekend and busy-day booking preference',
              ),
            ].map((b) => _BenefitTile(title: b.$1, subtitle: b.$2)),
            const SizedBox(height: 24),
            Text('How It Works',
                style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 12),
            ...const [
              'Pay the yearly VIP amount.',
              'Share the payment screenshot on WhatsApp.',
              'VIP activation will be completed by the studio team.',
            ].asMap().entries.map(
                  (entry) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 12,
                          backgroundColor: AppTheme.primary.withOpacity(0.15),
                          child: Text(
                            '${entry.key + 1}',
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                  color: AppTheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(entry.value,
                              style: Theme.of(context).textTheme.bodyMedium),
                        ),
                      ],
                    ),
                  ),
                ),
            const SizedBox(height: 24),
            if (!isVIP) ...[
              if (!_showQR)
                GradientButton(
                  label: 'Get VIP - Rs $_vipPrice / year',
                  icon: Icons.workspace_premium,
                  onPressed: _showPaymentQR,
                  gradient: AppTheme.goldGradient,
                )
              else
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppTheme.cardDark,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppTheme.accent.withOpacity(0.5)),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Scan to Pay Rs $_vipPrice',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(color: AppTheme.accent),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Pay via GPay / PhonePe / Any UPI',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 16),
                      if (_qrDataUrl != null)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.memory(
                            base64Decode(_qrDataUrl!.split(',').last),
                            width: 220,
                            height: 220,
                          ),
                        )
                      else if (_qrLoading)
                        Column(
                          children: [
                            const CircularProgressIndicator(),
                            const SizedBox(height: 12),
                            Text(
                              'Loading payment QR...',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        )
                      else
                        Text(
                          'QR unavailable right now. Please try again.',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: AppTheme.warning),
                        ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppTheme.warning.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          'After payment, share your screenshot on WhatsApp: +91 83445 49199. VIP will be activated within 24 hours.',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: AppTheme.warning),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  String _formatDate(String dateStr) {
    try {
      final d = DateTime.parse(dateStr);
      return '${d.day}/${d.month}/${d.year}';
    } catch (_) {
      return dateStr;
    }
  }
}

class _BenefitTile extends StatelessWidget {
  final String title;
  final String subtitle;

  const _BenefitTile({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF2A2A3A)),
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: AppTheme.success, size: 20),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleMedium),
                Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
