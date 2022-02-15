import 'dart:async';
import 'package:dartz/dartz.dart';

import 'package:progiom_cms/core.dart';
import 'package:progiom_cms/ecommerce.dart';

import '../../../injections.dart';

class SearchBLoc extends SimpleLoaderBloc<List<Product>> {
  int page = 0;
  String query = "";
  int? minPrice;
  int? maxPrice;

  String orderColumn = "created_at";
  String orderDirection = "asc";
  int? categoryId;
  int? rating;
  SearchBLoc() : super(eventParams: "");

  @override
  Future<Either<Failure, List<Product>>> load(SimpleBlocEvent event) async {
    if (event is LoadEvent) page = 0;
    page++;

    return SearchProducts(sl()).call(SearchProductsParams(
        page: page,
        query: query,
        minPrice: minPrice
            ?.toString(), // if you delete ? then will send string "null"
        maxPrice: maxPrice
            ?.toString(), // if you delete ? then will send string "null"
        orderColumn: orderColumn,
        orderDirection: orderDirection,
        categoryId: categoryId,
        rating: rating));
  }
}
