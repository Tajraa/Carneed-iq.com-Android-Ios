import 'dart:async';
import 'package:dartz/dartz.dart';

import 'package:progiom_cms/core.dart';
import 'package:progiom_cms/ecommerce.dart';

import '../../../injections.dart';

class FavoriteBloc extends SimpleLoaderBloc<List<FavoriteItem>> {
  int page = 0;

  FavoriteBloc() : super(eventParams: "", hideLoadingAfterFirstSuccess: true);

  @override
  Future<Either<Failure, List<FavoriteItem>>> load(
      SimpleBlocEvent event) async {
    if (event is LoadEvent) page = 0;
    page++;

    return GetFavorites(sl()).call(GetFavoritesParams(page: page));
  }
}
