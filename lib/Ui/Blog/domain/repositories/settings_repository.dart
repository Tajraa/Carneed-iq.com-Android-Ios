import 'package:dartz/dartz.dart';
import 'package:progiom_cms/core.dart';
import 'package:progiom_cms/ecommerce.dart';
import 'package:tajra/Ui/Blog/domain/model/modelBlogCategory.dart';
import 'package:tajra/Ui/Blog/domain/model/modelBlogDetails.dart';
import 'package:tajra/Ui/Blog/domain/model/modelBloge.dart';

abstract class BlogRepository {
  Future<Either<Failure, List<Data>>> getLsitCategories(NoParams params);
  Future<Either<Failure, List<DataBlog>>> getLsitBlog(
      ProducatsByCategoryParams params);
  Future<Either<Failure, DataBlogDetalse>> getBlogDeta(String params);
}
