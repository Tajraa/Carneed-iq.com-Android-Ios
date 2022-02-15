import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:progiom_cms/core.dart';
import 'package:progiom_cms/ecommerce.dart';

import '../../../injections.dart';

part 'productdetails_event.dart';
part 'productdetails_state.dart';

class ProductdetailsBloc
    extends Bloc<ProductdetailsEvent, ProductdetailsState> {
  ProductdetailsBloc() : super(ProductdetailsInitial()) {
    on<GetDetails>(_onGetDetails);
  }

  _onGetDetails(GetDetails event, Emitter<ProductdetailsState> emit) async {
    emit(LoadingDetails());
    final useCase = GetProductDetails(sl());
    final result = await useCase.call(GetProductDetailsParams(id: event.id));
    result.fold((l) {
      emit(ErrorInDetails(l.errorMessage));
    }, (r) {
      emit(DetailsReady(r));
    });
  }
}
