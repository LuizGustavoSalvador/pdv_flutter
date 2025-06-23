part of 'sale_bloc.dart';

abstract class SaleState {}

/// Estado inicial, antes de qualquer interação.
class SaleInitial extends SaleState {}

/// Estado que representa o carrinho de compras atual.
class SaleLoaded extends SaleState {
  final List<Map<String, dynamic>> cartItems;
  SaleLoaded({required this.cartItems});
}

/// Estado de carregamento, usado ao finalizar a venda.
class SaleLoading extends SaleState {}

/// Estado de sucesso após a finalização da venda.
class SaleSuccess extends SaleState {}

/// Estado de falha, caso ocorra um erro.
class SaleFailure extends SaleState {
  final String error;
  SaleFailure(this.error);
}
