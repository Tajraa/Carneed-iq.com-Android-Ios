import 'package:dartz/dartz.dart';
import 'package:progiom_cms/core.dart';
import 'package:tajra/Ui/Blog/domain/model/modelBlogCategory.dart';
import 'package:tajra/Ui/Blog/domain/repositories/settings_repository.dart';

class GetLsitCategories extends UseCase<List<Data>, NoParams> {
  final BlogRepository repository;

  GetLsitCategories(
    this.repository,
  );

  @override
  Future<Either<Failure, List<Data>>> call(NoParams params) async {
    return await repository.getLsitCategories(params);
  }
}
