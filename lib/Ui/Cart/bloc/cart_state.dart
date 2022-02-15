part of 'cart_bloc.dart';

@immutable
abstract class CartState {}

class CartInitial extends CartState {}

class LoadingCart extends CartState {}

class CartReady extends CartState {
  final CartModel cartModel;
  final bool isRefreshing;
  CartReady(this.cartModel, {this.isRefreshing = false});

  CartReady copyWith({
    CartModel? cartModel,
    bool? isRefreshing,
  }) {
    return CartReady(
      cartModel ?? this.cartModel,
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }
}

class ErrorInCart extends CartState {
  final String error;

  ErrorInCart(this.error);
}

class ErrorInOperation extends CartState {
  final String error;
  ErrorInOperation(this.error);
}

class CouponAccepted extends CartState {
  final UseCouponResponse useCouponResponse;
  CouponAccepted(this.useCouponResponse);
}

class CheckingCoupon extends CartState {}

class ErrorInCoupon extends CartState {
  final String error;
  ErrorInCoupon(this.error);
}
