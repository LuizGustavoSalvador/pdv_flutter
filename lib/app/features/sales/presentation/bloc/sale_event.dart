part of 'sale_bloc.dart';

abstract class SaleEvent {}

/// Evento disparado para finalizar a venda.
/// É uma boa prática passar os dados necessários (como os itens do carrinho)
/// diretamente no evento, para tornar o BLoC mais robusto.
class FinalizeSaleRequested extends SaleEvent {
  final List<Map<String, dynamic>> cartItems;

  FinalizeSaleRequested({required this.cartItems});
}
