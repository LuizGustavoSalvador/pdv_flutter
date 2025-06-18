import 'package:flutter/material.dart';
import 'package:pdv_flutter/app/core/enums/home_section_enum.dart';
import 'package:pdv_flutter/app/core/l10n/strings.dart';

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

  Future<void> _confirmLogout(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(Strings.confirmation),
        content: const Text(Strings.logoutConfirmText),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text(Strings.no),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text(Strings.yes),
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
    // Índice do botão "Sair" (o último)
    final logoutIndex = HomeSection.values.length;

    return NavigationRail(
      selectedIndex: currentSection.index,
      onDestinationSelected: (int index) {
        if (index == logoutIndex) {
          _confirmLogout(context);
        } else {
          onSectionChanged(HomeSection.values[index]);
        }
      },
      labelType: NavigationRailLabelType.all,
      destinations: const [
        NavigationRailDestination(
          icon: Icon(Icons.dashboard),
          label: Text('Início'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.store),
          label: Text('Produtos'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.receipt),
          label: Text('Pedidos'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.settings),
          label: Text('Configurações'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.logout),
          label: Text('Sair'),
        ),
      ],
    );
  }
}
