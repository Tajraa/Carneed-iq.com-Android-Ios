import 'package:dartz/dartz.dart';
import 'package:progiom_cms/core.dart';
import 'package:progiom_cms/ecommerce.dart';
import 'package:tajra/Ui/Blog/domain/model/modelBlogCategory.dart';
import 'package:tajra/Ui/Blog/domain/model/modelBlogDetails.dart';
import 'package:tajra/Ui/Blog/domain/model/modelBloge.dart';
import 'package:tajra/Ui/Blog/domain/repositories/settings_repository.dart';

class GeBlogdeta extends UseCase<DataBlogDetalse, String> {
  final BlogRepository repository;

  GeBlogdeta(
    this.repository,
  );

  @override
  Future<Either<Failure, DataBlogDetalse>> call(String params) async {
    return await repository.getBlogDeta(params);
  }
}
