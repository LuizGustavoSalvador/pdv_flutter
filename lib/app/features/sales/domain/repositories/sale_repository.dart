abstract class SaleRepository {
  /// Finaliza a venda, salvando localmente e tentando sincronizar com a API.
  /// O `cartItems` é a lista de produtos vinda do carrinho.
  Future<void> finalizeSale(List<Map<String, dynamic>> cartItems);
}
