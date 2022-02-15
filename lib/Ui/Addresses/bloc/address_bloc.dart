import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:progiom_cms/ecommerce.dart';
import '/injections.dart';

part 'address_event.dart';
part 'address_state.dart';

class AddressBloc extends Bloc<AddressEvent, AddressState> {
  AddressBloc() : super(AddaddressInitial()) {
    on<AddAddressEvent>(_onAddAddress);
    on<UpdateAddressEvent>(_onUpdateAddress);
    on<DeleteAddressEvent>(_onDeleteAddress);
    on<SetDefaultAddressEvent>(_onSetDefaultAddress);
  }

 _onSetDefaultAddress(
      SetDefaultAddressEvent event, Emitter<AddressState> emit) async {
    emit(LoadingState());
    final result = await SetDefaultAddress(sl())
        .call(SetDefaultAddressParams(addressId: event.addressId));

    result.fold((l) {
      emit(ErrorState(l.errorMessage));
    }, (r) {
      emit(AddressSuccessState());
    });
  }

  Future<void> _onDeleteAddress(
      DeleteAddressEvent event, Emitter<AddressState> emit) async {
    emit(LoadingState());
    final result = await DeleteAddress(sl())
        .call(DeleteAddressParams(id: event.addressId));

    result.fold((l) {
      emit(ErrorState(l.errorMessage));
    }, (r) {
      emit(AddressSuccessState());
    });
  }

  Future<void> _onUpdateAddress(
      UpdateAddressEvent event, Emitter<AddressState> emit) async {
    emit(LoadingState());
    final result = await UpdateAddress(sl()).call(UpdateAddressParams(
        cityId: event.cityId,
        countryId: event.countryId,
        name: event.name,
        id: event.id,
        description: event.description));

    result.fold((l) {
      emit(ErrorState(l.errorMessage));
    }, (r) {
      emit(AddressSuccessState());
    });
  }

  Future<void> _onAddAddress(
      AddAddressEvent event, Emitter<AddressState> emit) async {
    emit(LoadingState());
    final result = await AddAddress(sl()).call(AddAddressParams(
        cityId: event.cityId,
        countryId: event.countryId,
        name: event.name,
        description: event.description));

    result.fold((l) {
      emit(ErrorState(l.errorMessage));
    }, (r) {
      emit(AddressSuccessState());
    });
  }
}
