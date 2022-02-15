import 'dart:async';
import 'package:dartz/dartz.dart';

import 'package:progiom_cms/core.dart';
import 'package:progiom_cms/ecommerce.dart';

import '/injections.dart';

class MyAddressesBloc extends SimpleLoaderBloc<List<Address>> {
  int page = 0;

  MyAddressesBloc() : super(eventParams: "");

  @override
  Future<Either<Failure, List<Address>>> load(SimpleBlocEvent event) async {
    if (event is LoadEvent) page = 0;
    page++;

    return GetMyAddresses(sl()).call(NoParams());
  }
}
