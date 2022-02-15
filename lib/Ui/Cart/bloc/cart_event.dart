part of 'cart_bloc.dart';

@immutable
abstract class CartEvent {}

class GetCartEvent extends CartEvent {}



class UpdateCartEvent extends CartEvent {
  final int productId;
  final int qty;
  UpdateCartEvent({required this.productId, required this.qty});
}

class DeleteFromCartEvent extends CartEvent {
  final int productId;
  DeleteFromCartEvent(this.productId);
}

class UseCouponEvent extends CartEvent {
  final String code;
  UseCouponEvent(this.code);
}
