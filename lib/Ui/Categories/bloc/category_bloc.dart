import 'dart:async';
import 'package:dartz/dartz.dart';

import 'package:progiom_cms/core.dart';
import 'package:progiom_cms/ecommerce.dart';
import 'package:progiom_cms/homeSettings.dart';

import '../../../injections.dart';

class CategoryBloc extends SimpleLoaderBloc<List<Product>> {
  int page = 0;
  int? minPrice;
  int? maxPrice;
  String orderColumn = "created_at";
  String orderDirection = "asc";
  int? categoryId;
  int? rating;

  CategoryBloc(GetProducatsByCategoryParams params)
      : super(eventParams: params);

  @override
  Future<Either<Failure, List<Product>>> load(SimpleBlocEvent event) async {
    if (event is LoadEvent) {
      page = 0;
    }
    page++;
    if (event is LoadMoreEvent) print('params ar ${event.params.categoryId}');
    final String parentId = (event is LoadEvent)
        ? event.params['categoryId']
        : (event is LoadMoreEvent)
            ? event.params.categoryId
            : "";
    return GetProducatsByCategory(sl()).call(ProducatsByCategoryParams(
        parentId: parentId,
        page: page,
        minPrice: minPrice?.toString(),
        // if you delete ? then will send string "null"
        maxPrice: maxPrice?.toString(),
        // if you delete ? then will send string "null"
        orderColumn: orderColumn,
        orderDirection: orderDirection,
        categoryId: categoryId,
        rating: rating,
        filterValues: (event is LoadEvent)
            ? event.params['_field_values'] as Map<int, dynamic>?
            : null));
  }
}

class GetProducatsByCategoryParams {
  final String categoryId;

  GetProducatsByCategoryParams({required this.categoryId});
}
