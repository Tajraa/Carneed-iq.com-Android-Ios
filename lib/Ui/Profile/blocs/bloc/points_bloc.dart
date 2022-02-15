import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:progiom_cms/core.dart';
import 'package:progiom_cms/ecommerce.dart';

import '../../../../injections.dart';

part 'points_event.dart';
part 'points_state.dart';

class PointsBloc extends Bloc<PointsEvent, PointsState> {
  PointsBloc() : super(PointsInitial()) {
    on<GetMyPointEvent>(_onGetMyPoint);
  }

  Future<void> _onGetMyPoint(
      GetMyPointEvent event, Emitter<PointsState> emit) async {
    emit(LoadingPoints());
    final result = await GetMyPoints(sl()).call(NoParams());
    result.fold((l) {
      emit(ErrorInPoints(l.errorMessage));
    }, (r) {
      emit(PointReady(r));
    });
  }
}
