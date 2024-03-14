import 'package:flutter/material.dart';

class NavDestination extends StatelessWidget {
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  const NavDestination({
    super.key,
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationDestination(
      // tooltip: "Home",
      selectedIcon: Icon(
        selectedIcon,
        color: Theme.of(context).colorScheme.primary,
      ),
      icon: Icon(
        icon,
        color: Theme.of(context).colorScheme.primary,
      ),
      label: label,
    );
  }
}
