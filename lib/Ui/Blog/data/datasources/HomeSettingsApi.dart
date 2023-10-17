import 'package:dio/dio.dart';
import 'package:progiom_cms/core.dart';
import 'package:progiom_cms/ecommerce.dart';
import 'package:tajra/Ui/Blog/domain/model/modelBlogCategory.dart';
import 'package:tajra/Ui/Blog/domain/model/modelBlogDetails.dart';
import 'package:tajra/Ui/Blog/domain/model/modelBloge.dart';
import 'package:tajra/injections.dart';

class BlogApi {
  BlogApi();

  Future<List<Data>> getLsitCategories(NoParams params) async {
    try {
      final response = await sl<Dio>().get("/api/blog_post_categories");

      final BlogModel model = BlogModel.fromJson(response.data);
      return model.data!;
    } on DioError catch (e) {
      throw ServerException(handleDioError(e));
    } catch (e) {
      print(e.toString());
      throw ServerException(e.toString());
    }
  }

  Future<List<DataBlog>> getLsitBlog(ProducatsByCategoryParams params) async {
    try {
      final response = await sl<Dio>().get(
          "/api/blog_posts?parent_id=${params.parentId}&page=${params.page}");

      final Blog model = Blog.fromJson(response.data);
      return model.data!;
    } on DioError catch (e) {
      throw ServerException(handleDioError(e));
    } catch (e) {
      print(e.toString());
      throw ServerException(e.toString());
    }
  }

  Future<DataBlogDetalse> getBlogDeta(String params) async {
    try {
      final response = await sl<Dio>().get("/api/blog_posts/$params");

      final DataBlogDetalse model = DataBlogDetalse.fromJson(response.data);
      return model;
    } on DioError catch (e) {
      throw ServerException(handleDioError(e));
    } catch (e) {
      print(e.toString());
      throw ServerException(e.toString());
    }
  }
}
