import 'package:flutter/material.dart';

// Aqui ficaria sua enum para navegação, se quiser organizar mais
enum HomeSection { home, products, orders, settings }

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ThemeMode _themeMode = ThemeMode.light;
  HomeSection _currentSection = HomeSection.home;

  // Simulação de carrinho/pedido
  List<Map<String, dynamic>> cartItems = [];
  double subtotal = 0.0;

  void _addToCart(String name, double price) {
    setState(() {
      cartItems.add({'name': name, 'price': price});
      subtotal += price;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: _themeMode,
      theme: ThemeData.light(useMaterial3: true),
      darkTheme: ThemeData.dark(useMaterial3: true),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Row(
          children: [
            // MENU LATERAL
            Container(
              width: 100,
              color: Theme.of(context).colorScheme.surfaceContainerHigh,
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  _SidebarButton(
                    icon: Icons.dashboard,
                    label: 'Início',
                    selected: _currentSection == HomeSection.home,
                    onTap: () =>
                        setState(() => _currentSection = HomeSection.home),
                  ),
                  _SidebarButton(
                    icon: Icons.store,
                    label: 'Produtos',
                    selected: _currentSection == HomeSection.products,
                    onTap: () =>
                        setState(() => _currentSection = HomeSection.products),
                  ),
                  _SidebarButton(
                    icon: Icons.receipt,
                    label: 'Pedidos',
                    selected: _currentSection == HomeSection.orders,
                    onTap: () =>
                        setState(() => _currentSection = HomeSection.orders),
                  ),
                  _SidebarButton(
                    icon: Icons.settings,
                    label: 'Config.',
                    selected: _currentSection == HomeSection.settings,
                    onTap: () =>
                        setState(() => _currentSection = HomeSection.settings),
                  ),
                  const Spacer(),
                  _SidebarButton(
                    icon: Icons.logout,
                    label: 'Sair',
                    selected: false,
                    onTap: () {
                      // TODO: lógica de logout
                      Navigator.of(context).pushReplacementNamed('/');
                    },
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: _buildSectionWidget(),
              ),
            ),
            Container(
              width: 400,
              color: Theme.of(context).colorScheme.surfaceVariant,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        icon: Icon(
                          _themeMode == ThemeMode.dark
                              ? Icons.wb_sunny_outlined
                              : Icons.nights_stay_outlined,
                        ),
                        tooltip: _themeMode == ThemeMode.dark
                            ? 'Tema claro'
                            : 'Tema escuro',
                        onPressed: () {
                          setState(() {
                            _themeMode = _themeMode == ThemeMode.dark
                                ? ThemeMode.light
                                : ThemeMode.dark;
                          });
                        },
                      ),
                    ),
                    Text(
                      'Checkout',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const Divider(),
                    Expanded(
                      child: ListView.builder(
                        itemCount: cartItems.length,
                        itemBuilder: (_, i) {
                          final item = cartItems[i];
                          return ListTile(
                            dense: true,
                            title: Text(item['name']),
                            trailing: Text(
                              'R\$ ${item['price'].toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Subtotal: R\$ ${subtotal.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red[100],
                              foregroundColor: Colors.red[800],
                            ),
                            onPressed: () => setState(() {
                              cartItems.clear();
                              subtotal = 0.0;
                            }),
                            child: const Text('Cancelar'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: cartItems.isEmpty
                                ? null
                                : () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Venda finalizada!'),
                                      ),
                                    );
                                    setState(() {
                                      cartItems.clear();
                                      subtotal = 0.0;
                                    });
                                  },
                            child: const Text('Finalizar Venda'),
                          ),
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
    );
  }

  Widget _buildSectionWidget() {
    switch (_currentSection) {
      case HomeSection.home:
        return GridView.count(
          crossAxisCount: 3,
          crossAxisSpacing: 32,
          mainAxisSpacing: 32,
          children: [
            _DashboardCard(
              icon: Icons.coffee,
              label: 'Café Expresso',
              color: Colors.brown[200],
              onTap: () => _addToCart('Café Expresso', 6.00),
            ),
            _DashboardCard(
              icon: Icons.fastfood,
              label: 'X-Burger',
              color: Colors.amber[200],
              onTap: () => _addToCart('X-Burger', 18.00),
            ),
            // ... outros cards de produtos/categorias
          ],
        );
      case HomeSection.products:
        return const Center(child: Text('Gestão de Produtos (em breve)'));
      case HomeSection.orders:
        return const Center(child: Text('Pedidos (em breve)'));
      case HomeSection.settings:
        return const Center(child: Text('Configurações (em breve)'));
    }
  }
}

// Sidebar Button Widget
class _SidebarButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _SidebarButton({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected
          ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
          : Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          width: double.infinity,
          height: 64,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: selected ? Theme.of(context).colorScheme.primary : null,
              ),
              const SizedBox(height: 6),
              Text(label, style: TextStyle(fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }
}

// Card central de produto/categoria
class _DashboardCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;
  final VoidCallback? onTap;

  const _DashboardCard({
    required this.icon,
    required this.label,
    this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color ?? Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 48, color: Colors.black87),
              const SizedBox(height: 16),
              Text(label, style: Theme.of(context).textTheme.titleMedium),
            ],
          ),
        ),
      ),
    );
  }
}
