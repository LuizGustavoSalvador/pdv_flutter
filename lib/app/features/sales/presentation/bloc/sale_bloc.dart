import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdv_flutter/app/features/sales/domain/repositories/sale_repository.dart';

part 'sale_event.dart';
part 'sale_state.dart';

class SaleBloc extends Bloc<SaleEvent, SaleState> {
  final SaleRepository _saleRepository;

  SaleBloc({required SaleRepository saleRepository})
    : _saleRepository = saleRepository,
      super(SaleInitial()) {
    on<FinalizeSaleRequested>(_onFinalizeSaleRequested);
  }

  Future<void> _onFinalizeSaleRequested(
    FinalizeSaleRequested event,
    Emitter<SaleState> emit,
  ) async {
    emit(SaleLoading()); // Mostra um indicador de loading na UI
    try {
      // É uma boa prática passar os dados necessários (como os itens do carrinho)
      // diretamente no evento. Isso torna o BLoC mais robusto e testável.
      await _saleRepository.finalizeSale(event.cartItems);
      emit(SaleSuccess()); // Emite estado de sucesso
    } catch (e) {
      emit(SaleFailure(e.toString())); // Emite estado de erro
    }
  }
}
