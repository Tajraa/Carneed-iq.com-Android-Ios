import 'dart:async';
import 'package:dartz/dartz.dart';

import 'package:progiom_cms/core.dart';
import 'package:progiom_cms/ecommerce.dart';

import '../../../injections.dart';

class CategoryBloc extends SimpleLoaderBloc<List<Product>> {
  int page = 0;

  CategoryBloc(GetProducatsByCategoryParams params)
      : super(eventParams: params);

  @override
  Future<Either<Failure, List<Product>>> load(SimpleBlocEvent event) async {
    if (event is LoadEvent) page = 0;
    page++;
    final String parentId = (event is LoadEvent)
        ? event.params.categoryId
        : (event is LoadMoreEvent)
            ? event.params.categoryId
            : "";
    return GetProducatsByCategory(sl())
        .call(ProducatsByCategoryParams(parentId: parentId, page: page));
  }
}

class GetProducatsByCategoryParams {
  final String categoryId;
  GetProducatsByCategoryParams({required this.categoryId});
}
