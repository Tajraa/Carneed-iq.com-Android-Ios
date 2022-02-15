part of 'address_bloc.dart';

@immutable
abstract class AddressEvent {}

class AddAddressEvent extends AddressEvent {
  final int countryId;
  final int cityId;
  final String name;
  final String description;

  AddAddressEvent({
    required this.cityId,
    required this.countryId,
    required this.name,
    required this.description,
  });
}

class UpdateAddressEvent extends AddressEvent {
  final int countryId;
  final int cityId;
  final String name;
  final String description;
  final int id;
  UpdateAddressEvent(
      {required this.cityId,
      required this.countryId,
      required this.name,
      required this.description,
      required this.id});
}

class DeleteAddressEvent extends AddressEvent {
  final int addressId;
  DeleteAddressEvent(this.addressId);
}


class SetDefaultAddressEvent extends AddressEvent {
  final int addressId;
  SetDefaultAddressEvent(this.addressId);
}
