part of 'orderdetails_bloc.dart';

@immutable
abstract class OrderdetailsState {}

class OrderdetailsInitial extends OrderdetailsState {}

class OrderDetailsReady extends OrderdetailsState {
  final OrderItem order;
  OrderDetailsReady(this.order);
}

class LoadingDetails extends OrderdetailsState {}

class ErrorInDetails extends OrderdetailsState {
  final String error;
  ErrorInDetails(this.error);
}
