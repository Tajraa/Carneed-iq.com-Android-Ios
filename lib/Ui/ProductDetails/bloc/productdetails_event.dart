part of 'productdetails_bloc.dart';

@immutable
abstract class ProductdetailsEvent {}

class GetDetails extends ProductdetailsEvent {
  final String id;
  GetDetails(this.id);
}
