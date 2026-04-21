import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:veeras_beauty/core/theme.dart';

class MainShell extends ConsumerStatefulWidget {
  final Widget child;
  const MainShell({super.key, required this.child});

  @override
  ConsumerState<MainShell> createState() => _MainShellState();
}

class _MainShellState extends ConsumerState<MainShell> {
  final List<_NavItem> _navItems = const [
    _NavItem(label: 'Home', icon: Icons.home_outlined, activeIcon: Icons.home_rounded, path: '/'),
    _NavItem(label: 'Services', icon: Icons.spa_outlined, activeIcon: Icons.spa_rounded, path: '/services'),
    _NavItem(label: 'Academy', icon: Icons.play_circle_outline, activeIcon: Icons.play_circle, path: '/academy'),
    _NavItem(label: 'Profile', icon: Icons.person_outline, activeIcon: Icons.person_rounded, path: '/profile'),
  ];

  void _onNavTap(int index) {
    context.go(_navItems[index].path);
  }

  int _selectedIndexForLocation(String location) {
    if (location.startsWith('/services')) return 1;
    if (location.startsWith('/academy') ||
        location.startsWith('/course') ||
        location.startsWith('/lesson') ||
        location.startsWith('/my-courses')) {
      return 2;
    }
    if (location.startsWith('/profile') || location.startsWith('/my-bookings')) {
      return 3;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    final selectedIndex = _selectedIndexForLocation(location);

    return Scaffold(
      body: widget.child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppTheme.surfaceDark,
          border: const Border(top: BorderSide(color: Color(0xFF2A2A3A))),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: SizedBox(
            height: 64,
            child: Row(
              children: List.generate(_navItems.length, (i) {
                final item = _navItems[i];
                final isSelected = selectedIndex == i;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => _onNavTap(i),
                    behavior: HitTestBehavior.opaque,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                            decoration: BoxDecoration(
                              color: isSelected ? AppTheme.primary.withOpacity(0.15) : Colors.transparent,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Icon(
                              isSelected ? item.activeIcon : item.icon,
                              color: isSelected ? AppTheme.primary : AppTheme.textMuted,
                              size: 22,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            item.label,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                              color: isSelected ? AppTheme.primary : AppTheme.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final String label;
  final IconData icon;
  final IconData activeIcon;
  final String path;
  const _NavItem({required this.label, required this.icon, required this.activeIcon, required this.path});
}
