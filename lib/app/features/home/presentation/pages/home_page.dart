import 'package:flutter/material.dart';
import 'package:pdv_flutter/app/core/enums/home_section_enum.dart';
import 'home_menu.dart';
import 'home_dashboard.dart';
import 'home_checkout.dart';

class HomePage extends StatefulWidget {
  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;

  const HomePage({
    super.key,
    required this.themeMode,
    required this.onThemeModeChanged,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomeSection _currentSection = HomeSection.home;

  List<Map<String, dynamic>> cartItems = [];
  double subtotal = 0.0;

  void _addToCart(String name, double price) {
    setState(() {
      cartItems.add({'name': name, 'price': price});
      subtotal = cartItems.fold(0, (s, i) => s + (i['price'] as double));
    });
  }

  void _onSectionChanged(HomeSection section) {
    setState(() {
      _currentSection = section;
    });
  }

  void _onCancel() {
    setState(() {
      cartItems.clear();
      subtotal = 0.0;
    });
  }

  void _onCheckout() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Venda finalizada!')));
    setState(() {
      cartItems.clear();
      subtotal = 0.0;
    });
  }

  Future<void> _confirmLogout(BuildContext context) async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Sair'),
        content: const Text('Deseja realmente sair do sistema?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Sair'),
          ),
        ],
      ),
    );

    if (shouldLogout == true) {
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          HomeMenu(
            currentSection: _currentSection,
            onSectionChanged: _onSectionChanged,
            onLogout: () => _confirmLogout(context),
          ),
          // Painel central
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: _buildSectionWidget(),
            ),
          ),
          HomeCheckout(
            cartItems: cartItems,
            subtotal: subtotal,
            onCancel: _onCancel,
            onCheckout: _onCheckout,
            themeMode: widget.themeMode,
            onThemeModeChanged: widget.onThemeModeChanged,
            onRemoveCartItem: (int index) {
              setState(() {
                cartItems.removeAt(index);
                subtotal = cartItems.fold(
                  0,
                  (s, i) => s + (i['price'] as double),
                );
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionWidget() {
    switch (_currentSection) {
      case HomeSection.home:
        return HomeDashboard(onAddToCart: _addToCart);
      case HomeSection.products:
        return const Center(child: Text('Gestão de Produtos (em breve)'));
      case HomeSection.orders:
        return const Center(child: Text('Pedidos (em breve)'));
      case HomeSection.settings:
        return const Center(child: Text('Configurações (em breve)'));
    }
  }
}
