import 'package:dartz/dartz.dart';
import 'package:progiom_cms/core.dart';
import 'package:progiom_cms/ecommerce.dart';
import 'package:tajra/Ui/Blog/data/datasources/HomeSettingsApi.dart';
import 'package:tajra/Ui/Blog/domain/model/modelBlogCategory.dart';
import 'package:tajra/Ui/Blog/domain/model/modelBlogDetails.dart';
import 'package:tajra/Ui/Blog/domain/model/modelBloge.dart';
import 'package:tajra/Ui/Blog/domain/repositories/settings_repository.dart';

class BlogRepositoryImpl implements BlogRepository {
  late final BlogApi blogApi;

  BlogRepositoryImpl(this.blogApi);

  @override
  Future<Either<Failure, List<Data>>> getLsitCategories(NoParams params) async {
    try {
      final result = await blogApi.getLsitCategories(params);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<DataBlog>>> getLsitBlog(
      ProducatsByCategoryParams params) async {
    try {
      final result = await blogApi.getLsitBlog(params);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, DataBlogDetalse>> getBlogDeta(String params) async {
    try {
      final result = await blogApi.getBlogDeta(params);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
