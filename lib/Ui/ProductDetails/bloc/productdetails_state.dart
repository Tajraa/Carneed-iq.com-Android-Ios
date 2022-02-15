part of 'productdetails_bloc.dart';

@immutable
abstract class ProductdetailsState {}

class ProductdetailsInitial extends ProductdetailsState {}

class DetailsReady extends ProductdetailsState {
  final Product product;
  DetailsReady(this.product);
}

class LoadingDetails extends ProductdetailsState {}

class ErrorInDetails extends ProductdetailsState {
  final String error;
  ErrorInDetails(this.error);
}
