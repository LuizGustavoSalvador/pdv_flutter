import 'package:flutter/material.dart';
import 'package:pdv_flutter/app/core/l10n/app_localizations.dart';
import 'package:pdv_flutter/app/features/products/data/product_repository.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({Key? key}) : super(key: key);

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  List<Map<String, dynamic>> products = [];

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    products = await ProductRepository().getProducts();
    setState(() {});
  }

  Future<void> _addProduct() async {
    final l10n = AppLocalizations.of(context)!;

    await ProductRepository().insertProduct('Novo Produto', 10.0);
    await _loadProducts();
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(l10n.productSaved)));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.productsTitle)),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (_, i) => ListTile(
          title: Text(products[i]['name']),
          subtitle: Text('R\$ ${products[i]['price'].toStringAsFixed(2)}'),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              await ProductRepository().deleteProduct(products[i]['id']);
              await _loadProducts();
              if (!mounted) return;
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(l10n.productDeleted)));
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: l10n.addProduct,
        onPressed: _addProduct,
        child: const Icon(Icons.add),
      ),
    );
  }
}
