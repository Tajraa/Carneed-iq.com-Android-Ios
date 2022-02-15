part of 'points_bloc.dart';

@immutable
abstract class PointsState {}

class PointsInitial extends PointsState {}

class LoadingPoints extends PointsState {}

class PointReady extends PointsState {
  final MyPointsResponse pointsResponse;
  PointReady(this.pointsResponse);
}

class ErrorInPoints extends PointsState {
  final String error;
  ErrorInPoints(this.error);
}
