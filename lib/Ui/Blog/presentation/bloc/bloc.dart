export 'homesettings_bloc.dart';
import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:progiom_cms/core.dart';
import 'package:progiom_cms/ecommerce.dart';

import 'package:tajra/Ui/Blog/domain/model/modelBloge.dart';
import 'package:tajra/Ui/Blog/domain/usecases/get_blog.dart';
import '../../../../injections.dart';

class BlogBlocpaje extends SimpleLoaderBloc<List<DataBlog>> {
  int page = 0;

  int? categoryId;

  BlogBlocpaje(GetProducatsByCategoryParams params)
      : super(eventParams: params);

  @override
  Future<Either<Failure, List<DataBlog>>> load(SimpleBlocEvent event) async {
    if (event is LoadEvent) {
      page = 0;
    }
    page++;
    if (event is LoadMoreEvent) print('params ar ${event.params.categoryId}');
    final String parentId = (event is LoadEvent)
        ? event.params['parent_id']
        : (event is LoadMoreEvent)
            ? event.params.categoryId
            : "";
    return GetLsitBlog(sl()).call(ProducatsByCategoryParams(
      parentId: parentId,
      page: page,
    ));
  }
}

class GetProducatsByCategoryParams {
  final String categoryId;

  GetProducatsByCategoryParams({required this.categoryId});
}
