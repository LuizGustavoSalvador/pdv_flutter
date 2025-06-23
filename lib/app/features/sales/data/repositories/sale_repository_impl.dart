import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:pdv_flutter/app/core/database/sqlite_connection_factory.dart';
import 'package:pdv_flutter/app/features/sales/data/datasources/fiscal_api_datasource.dart';
import 'package:pdv_flutter/app/features/sales/domain/repositories/sale_repository.dart';

class SaleRepositoryImpl implements SaleRepository {
  final FiscalApiDataSource _fiscalApiDataSource;
  final SqliteConnectionFactory _connectionFactory;
  final Connectivity _connectivity;

  SaleRepositoryImpl({
    required FiscalApiDataSource fiscalApiDataSource,
    required SqliteConnectionFactory connectionFactory,
    required Connectivity connectivity,
  }) : _fiscalApiDataSource = fiscalApiDataSource,
       _connectionFactory = connectionFactory,
       _connectivity = connectivity;

  @override
  Future<void> finalizeSale(List<Map<String, dynamic>> cartItems) async {
    final db = await _connectionFactory.openConnection();
    int saleId;

    // 1. Salvar a venda e os itens localmente dentro de uma transação
    saleId = await db.transaction((txn) async {
      final total = cartItems.fold<double>(
        0.0,
        (sum, item) => sum + item['price'],
      );

      final id = await txn.insert('sales', {
        'total': total,
        'created_at': DateTime.now().toIso8601String(),
        'status': 'PENDING_SYNC', // Começa como pendente
      });

      for (var item in cartItems) {
        await txn.insert('sale_items', {
          'sale_id': id,
          'product_id': item['id'],
          'quantity': 1, // Ajuste conforme sua lógica de carrinho
          'price': item['price'],
        });
      }
      return id;
    });

    // 2. Verificar conectividade
    final connectivityResult = await _connectivity.checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.wifi)) {
      try {
        // 3. Se online, tentar enviar para a API
        final saleDataForApi = {
          'local_id': saleId,
          'items': cartItems,
          // ... outros dados que sua API precisa
        };
        await _fiscalApiDataSource.emitSale(saleDataForApi);

        // 4. Se sucesso, atualizar o status local
        await db.update(
          'sales',
          {'status': 'EMITTED'},
          where: 'id = ?',
          whereArgs: [saleId],
        );
      } catch (e) {
        // Se a API falhar, o status continua PENDING_SYNC para nova tentativa
        print('Erro ao sincronizar venda $saleId: $e');
      }
    }
  }
}
