import 'dart:async';
import 'package:dartz/dartz.dart';

import 'package:progiom_cms/core.dart';
import 'package:progiom_cms/notifications.dart';

import '../../../injections.dart';

class NotificationsBLoc extends SimpleLoaderBloc<List<ServerNotification>> {
  int page = 0;

  NotificationsBLoc() : super(eventParams: "");

  @override
  Future<Either<Failure, List<ServerNotification>>> load(
      SimpleBlocEvent event) async {
    if (event is LoadEvent) page = 0;
    page++;

    return GetMyNotifications(sl()).call(GetMyNotificationsParams(page: page));
  }
}
