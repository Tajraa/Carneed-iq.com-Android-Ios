import 'dart:async';
import 'package:dartz/dartz.dart';

import 'package:progiom_cms/core.dart';
import 'package:progiom_cms/ecommerce.dart';

import '../../../injections.dart';

class PointsProductsBloc extends SimpleLoaderBloc<List<Product>> {
  int page = 0;

  PointsProductsBloc(String params) : super(eventParams: params);

  @override
  Future<Either<Failure, List<Product>>> load(SimpleBlocEvent event) async {
    if (event is LoadEvent) page = 0;
    page++;

    return GetProducatsByPoints(sl()).call(ProducatsByPointsParams(page: page));
  }
}
