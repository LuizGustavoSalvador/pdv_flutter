import 'package:flutter/material.dart';
import 'package:pdv_flutter/app/core/enums/home_section_enum.dart';
import 'package:pdv_flutter/app/core/l10n/app_localizations.dart';

class HomeMenu extends StatelessWidget {
  final HomeSection currentSection;
  final ValueChanged<HomeSection> onSectionChanged;
  final VoidCallback onLogout;

  const HomeMenu({
    super.key,
    required this.currentSection,
    required this.onSectionChanged,
    required this.onLogout,
  });

  Future<void> _confirmLogout(
    BuildContext context,
    AppLocalizations l10n,
  ) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.confirmation),
        content: Text(l10n.logoutConfirmText),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l10n.no),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(l10n.yes),
          ),
        ],
      ),
    );
    if (result == true) {
      // Chama logout e navega para login limpando a stack
      onLogout();
      Navigator.of(context, rootNavigator: true).pushReplacementNamed('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    final logoutIndex = HomeSection.values.length;
    final l10n = AppLocalizations.of(context)!;

    return NavigationRail(
      selectedIndex: currentSection.index,
      onDestinationSelected: (int index) {
        if (index == logoutIndex) {
          _confirmLogout(context, l10n);
        } else {
          onSectionChanged(HomeSection.values[index]);
        }
      },
      labelType: NavigationRailLabelType.all,
      destinations: [
        NavigationRailDestination(
          icon: Icon(Icons.dashboard),
          label: Text(l10n.homeTitle),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.store),
          label: Text(l10n.productsTitle),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.receipt),
          label: Text(l10n.ordersTitle),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.settings),
          label: Text(l10n.settingsTitle),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.logout),
          label: Text(l10n.exit),
        ),
      ],
    );
  }
}
