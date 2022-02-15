import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:progiom_cms/core.dart';
import 'package:progiom_cms/ecommerce.dart';
import '/injections.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartInitial()) {
    on<GetCartEvent>(_onGetCart);
    on<UpdateCartEvent>(_onUpdateCart);
    on<DeleteFromCartEvent>(_onDeleteFromCart);
    on<UseCouponEvent>(_onuseCoupon);
  }

  Future<void> _onuseCoupon(
      UseCouponEvent event, Emitter<CartState> emit) async {
    emit(CheckingCoupon());
    final result =
        await UseCoupon(sl()).call(UseCouponParams(code: event.code));
    result.fold((l) {
      emit(ErrorInCoupon(l.errorMessage));
    }, (r) {
      emit(CouponAccepted(r));
    });
  }

  Future<void> _onDeleteFromCart(
      DeleteFromCartEvent event, Emitter<CartState> emit) async {
    final result = await DeleteFromCart(sl())
        .call(DeleteFromCartParams(cartItemId: event.productId));
    result.fold((l) {
      emit(ErrorInOperation(l.errorMessage));
    }, (r) {
      add(GetCartEvent());
      emit(state);
    });
  }

  Future<void> _onUpdateCart(
      UpdateCartEvent event, Emitter<CartState> emit) async {
    final result = await UpdateCartItem(sl()).call(UpdateCartItemParams(
      cartItemId: event.productId,
      qty: event.qty,
    ));
    result.fold((l) {
      emit(ErrorInOperation(l.errorMessage));
    }, (r) {
      add(GetCartEvent());
      emit(state);
    });
  }

  Future<void> _onGetCart(GetCartEvent event, Emitter<CartState> emit) async {
    if (state is CartReady) {
      emit((state as CartReady).copyWith(isRefreshing: true));
    } else {
      emit(LoadingCart());
    }
    final result = await GetCart(sl()).call(NoParams());
    result.fold((l) {
      emit(ErrorInCart(l.errorMessage));
    }, (r) {
      emit(CartReady(r));
    });
  }
}
