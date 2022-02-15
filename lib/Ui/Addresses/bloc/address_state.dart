part of 'address_bloc.dart';

@immutable
abstract class AddressState {}

class AddaddressInitial extends AddressState {}

class AddressSuccessState extends AddressState {}

class LoadingState extends AddressState {}

class ErrorState extends AddressState {
  final String error;
  ErrorState(this.error);
}
