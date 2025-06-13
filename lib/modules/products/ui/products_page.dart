import 'package:flutter/material.dart';
import 'package:pdv_flutter/modules/products/data/product_repository.dart';
import '../../../../core/l10n/strings.dart';

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
    await ProductRepository().insertProduct('Novo Produto', 10.0);
    await _loadProducts();
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(Strings.productSaved)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(Strings.productsTitle)),
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
              ).showSnackBar(SnackBar(content: Text(Strings.productDeleted)));
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: Strings.addProduct,
        onPressed: _addProduct,
        child: const Icon(Icons.add),
      ),
    );
  }
}
