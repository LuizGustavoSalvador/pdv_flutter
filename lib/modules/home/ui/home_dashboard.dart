import 'package:flutter/material.dart';

class HomeDashboard extends StatelessWidget {
  final void Function(String, double) onAddToCart;

  const HomeDashboard({super.key, required this.onAddToCart});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      crossAxisSpacing: 32,
      mainAxisSpacing: 32,
      children: [
        _DashboardCard(
          icon: Icons.coffee,
          label: 'Café Expresso',
          color: Colors.brown[200],
          onTap: () => onAddToCart('Café Expresso', 6.00),
        ),
        _DashboardCard(
          icon: Icons.fastfood,
          label: 'X-Burger',
          color: Colors.amber[200],
          onTap: () => onAddToCart('X-Burger', 18.00),
        ),
        // ... outros cards
      ],
    );
  }
}

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
