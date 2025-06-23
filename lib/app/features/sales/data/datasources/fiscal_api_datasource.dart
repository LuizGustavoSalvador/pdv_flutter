import 'dart:convert';
import 'package:http/http.dart' as http;

class FiscalApiDataSource {
  final http.Client _client;
  // Substitua pela URL da sua API
  final _baseUrl = 'https://api.seusistema.com/v1/nfe';

  FiscalApiDataSource({http.Client? client})
    : _client = client ?? http.Client();

  /// Envia os dados da venda para a API fiscal.
  /// O `saleData` deve ser um Map que a sua API espera.
  Future<void> emitSale(Map<String, dynamic> saleData) async {
    final response = await _client.post(
      Uri.parse(_baseUrl),
      headers: {
        'Content-Type': 'application/json',
        // Adicione aqui outros headers necessários, como o de autorização
        // 'Authorization': 'Bearer SEU_TOKEN_AQUI',
      },
      body: jsonEncode(saleData),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Erro ao emitir nota fiscal: ${response.body}');
    }
  }
}
