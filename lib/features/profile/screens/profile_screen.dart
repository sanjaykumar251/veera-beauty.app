import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:veeras_beauty/core/theme.dart';
import 'package:veeras_beauty/core/constants.dart';
import 'package:veeras_beauty/features/auth/providers/auth_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final userAsync = ref.watch(currentUserProvider);
    final isLoggedIn = authState.value != null;
    final user = userAsync.valueOrNull;
    final isVIP = ref.read(currentUserProvider.notifier).isVIP;

    if (!isLoggedIn) {
      return Scaffold(
        appBar: AppBar(title: const Text('Profile')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.person_outline, size: 80, color: AppTheme.textMuted),
                const SizedBox(height: 16),
                Text('Sign in to your account', style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 8),
                Text('Track bookings, enroll in courses, and unlock VIP benefits.',
                  style: Theme.of(context).textTheme.bodyMedium, textAlign: TextAlign.center),
                const SizedBox(height: 24),
                ElevatedButton(onPressed: () => context.push('/login'), child: const Text('Sign In')),
                const SizedBox(height: 12),
                TextButton(onPressed: () => context.push('/register'), child: const Text('Create Account')),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(gradient: AppTheme.heroGradient),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Avatar
                      Container(
                        width: 80, height: 80,
                        decoration: BoxDecoration(
                          gradient: isVIP ? AppTheme.goldGradient : AppTheme.primaryGradient,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            (user?['name'] ?? 'U').substring(0, 1).toUpperCase(),
                            style: const TextStyle(fontSize: 36, color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(user?['name'] ?? '', style: Theme.of(context).textTheme.headlineMedium),
                      Text(user?['email'] ?? '', style: Theme.of(context).textTheme.bodySmall),
                      if (isVIP) ...[
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                          decoration: BoxDecoration(
                            gradient: AppTheme.goldGradient,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.workspace_premium, color: Colors.white, size: 12),
                              SizedBox(width: 4),
                              Text('VIP Member', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Stats
                  Row(
                    children: [
                      _StatCard(label: 'Total Bookings', value: '${user?['totalBookings'] ?? 0}',
                        icon: Icons.calendar_today),
                      const SizedBox(width: 12),
                      _StatCard(label: 'Courses', value: '${(user?['enrolledCourses'] as List?)?.length ?? 0}',
                        icon: Icons.school_rounded),
                      const SizedBox(width: 12),
                      _StatCard(label: 'Membership', value: isVIP ? 'VIP' : 'Normal',
                        icon: Icons.workspace_premium, highlight: isVIP),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Menu
                  _MenuTile(icon: Icons.calendar_month_outlined, label: 'My Bookings',
                    onTap: () => context.push('/my-bookings')),
                  _MenuTile(icon: Icons.school_outlined, label: 'My Courses',
                    onTap: () => context.push('/my-courses')),
                  _MenuTile(icon: Icons.workspace_premium_outlined, label: 'VIP Membership',
                    badge: isVIP ? null : 'Get VIP',
                    onTap: () => context.push('/membership')),
                  _MenuTile(icon: Icons.chat_rounded, label: 'WhatsApp Us', color: const Color(0xFF25D366),
                    onTap: () => _openWhatsApp()),
                  _MenuTile(icon: Icons.call_rounded, label: 'Call Us',
                    onTap: () => _makeCall()),
                  _MenuTile(icon: Icons.location_on_outlined, label: 'Our Location',
                    onTap: () => _openMaps()),

                  const Divider(height: 32),

                  _MenuTile(
                    icon: Icons.logout,
                    label: 'Sign Out',
                    color: AppTheme.error,
                    onTap: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (c) => AlertDialog(
                          backgroundColor: AppTheme.cardDark,
                          title: const Text('Sign Out'),
                          content: const Text('Are you sure you want to sign out?'),
                          actions: [
                            TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('Cancel')),
                            TextButton(onPressed: () => Navigator.pop(c, true),
                              child: Text('Sign Out', style: TextStyle(color: AppTheme.error))),
                          ],
                        ),
                      );
                      if (confirm == true) {
                        await ref.read(authNotifierProvider.notifier).signOut();
                      }
                    },
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openWhatsApp() async {
    final url = Uri.parse('https://wa.me/${AppConstants.whatsappNumber}');
    if (await canLaunchUrl(url)) await launchUrl(url, mode: LaunchMode.externalApplication);
  }

  Future<void> _makeCall() async {
    final url = Uri.parse('tel:${AppConstants.phoneNumber}');
    if (await canLaunchUrl(url)) await launchUrl(url);
  }

  Future<void> _openMaps() async {
    const encoded = 'Veera\'s+Beauty+Tattoo+Studio+Cheyyar';
    final url = Uri.parse('https://www.google.com/maps/search/$encoded');
    if (await canLaunchUrl(url)) await launchUrl(url, mode: LaunchMode.externalApplication);
  }
}

class _StatCard extends StatelessWidget {
  final String label, value;
  final IconData icon;
  final bool highlight;
  const _StatCard({required this.label, required this.value, required this.icon, this.highlight = false});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          gradient: highlight ? AppTheme.goldGradient : null,
          color: highlight ? null : AppTheme.cardDark,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: highlight ? AppTheme.accent : const Color(0xFF2A2A3A)),
        ),
        child: Column(
          children: [
            Icon(icon, color: highlight ? Colors.white : AppTheme.primary, size: 22),
            const SizedBox(height: 6),
            Text(value, style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: highlight ? Colors.white : AppTheme.textPrimary,
            )),
            Text(label, style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: highlight ? Colors.white70 : AppTheme.textMuted,
            ), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;
  final String? badge;
  const _MenuTile({required this.icon, required this.label, required this.onTap, this.color, this.badge});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        onTap: onTap,
        tileColor: AppTheme.cardDark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        leading: Icon(icon, color: color ?? AppTheme.primary),
        title: Text(label, style: Theme.of(context).textTheme.titleMedium?.copyWith(color: color)),
        trailing: badge != null
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  gradient: AppTheme.goldGradient,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(badge!, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
              )
            : const Icon(Icons.chevron_right, color: AppTheme.textMuted, size: 20),
      ),
    );
  }
}
