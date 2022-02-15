import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:progiom_cms/ecommerce.dart';
import '/injections.dart';

part 'orderdetails_event.dart';
part 'orderdetails_state.dart';

class OrderdetailsBloc extends Bloc<OrderdetailsEvent, OrderdetailsState> {
  OrderdetailsBloc() : super(OrderdetailsInitial()) {
    on<GetOrderDetailsEvent>(_onGetOrderDetails);
  }

  _onGetOrderDetails(
      GetOrderDetailsEvent event, Emitter<OrderdetailsState> emit) async {
    emit(LoadingDetails());
    final result = await GetOrderDetails(sl())
        .call(GetOrderDetailsParams(orderId: event.orderId));

    result.fold((l) {
      emit(ErrorInDetails(l.errorMessage));
    }, (r) {
      emit(OrderDetailsReady(r));
    });
  }
}
