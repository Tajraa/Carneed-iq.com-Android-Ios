import 'dart:async';
import 'package:dartz/dartz.dart';

import 'package:progiom_cms/core.dart';
import 'package:progiom_cms/ecommerce.dart';

import '../../../injections.dart';

class OrdersBloc extends SimpleLoaderBloc<List<OrderItem>> {
  int page = 0;

  OrdersBloc() : super(eventParams: "");

  @override
  Future<Either<Failure, List<OrderItem>>> load(SimpleBlocEvent event) async {
    if (event is LoadEvent) page = 0;
    page++;

    return GetOrders(sl()).call(GetOrdersParams(page: page));
  }
}
