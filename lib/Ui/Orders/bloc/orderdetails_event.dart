part of 'orderdetails_bloc.dart';

@immutable
abstract class OrderdetailsEvent {}

class GetOrderDetailsEvent extends OrderdetailsEvent {
  final int orderId;
  GetOrderDetailsEvent(this.orderId);
}
