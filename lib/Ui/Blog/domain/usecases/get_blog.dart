import 'package:dartz/dartz.dart';
import 'package:progiom_cms/core.dart';
import 'package:progiom_cms/ecommerce.dart';
import 'package:tajra/Ui/Blog/domain/model/modelBlogCategory.dart';
import 'package:tajra/Ui/Blog/domain/model/modelBloge.dart';
import 'package:tajra/Ui/Blog/domain/repositories/settings_repository.dart';

class GetLsitBlog extends UseCase<List<DataBlog>, ProducatsByCategoryParams> {
  final BlogRepository repository;

  GetLsitBlog(
    this.repository,
  );

  @override
  Future<Either<Failure, List<DataBlog>>> call(
      ProducatsByCategoryParams params) async {
    return await repository.getLsitBlog(params);
  }
}
