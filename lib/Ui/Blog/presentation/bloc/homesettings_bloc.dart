import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:progiom_cms/Getit_instance.dart';
import 'package:progiom_cms/core.dart';
import 'package:progiom_cms/ecommerce.dart';
import 'package:tajra/Ui/Blog/domain/model/modelBlogCategory.dart';
import 'package:tajra/Ui/Blog/domain/model/modelBlogDetails.dart';
import 'package:tajra/Ui/Blog/domain/model/modelBloge.dart';
import 'package:tajra/Ui/Blog/domain/usecases/get_blog.dart';
import 'package:tajra/Ui/Blog/domain/usecases/get_blog_det.dart';
import 'package:tajra/Ui/Blog/domain/usecases/get_categories.dart';

part 'homesettings_event.dart';
part 'homesettings_state.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  BlogBloc() : super(BlogInitial()) {
    on<GetCategoryBlogs>(_onGetCategoryBlogs);
    on<GetBlogs>(_onGetBlogs);
    on<GetBlogdetails>(_onGetBlogDetails);
  }

  _onGetCategoryBlogs(GetCategoryBlogs event, Emitter<BlogState> emit) async {
    emit(LoadingSettings());

    final GetLsitCategories getLsitCategories = GetLsitCategories(sl());
    final result = await getLsitCategories.call(NoParams());

    result.fold((l) {
      emit(BlogError(l.errorMessage));
    }, (r) {
      emit(CategoryBlogReady(r));
    });
  }

  _onGetBlogs(GetBlogs event, Emitter<BlogState> emit) async {
    emit(LoadingSettings());

    final GetLsitBlog getLsitCategories = GetLsitBlog(sl());
    final result = await getLsitCategories
        .call(ProducatsByCategoryParams(parentId: event.categoryId));

    result.fold((l) {
      emit(BlogError(l.errorMessage));
    }, (r) {
      emit(BlogReady(r));
    });
  }

  _onGetBlogDetails(GetBlogdetails event, Emitter<BlogState> emit) async {
    emit(LoadingSettings());

    final GeBlogdeta getLsitCategories = GeBlogdeta(sl());
    final result = await getLsitCategories.call(event.Id);

    result.fold((l) {
      emit(BlogError(l.errorMessage));
    }, (r) {
      emit(BlogDetReady(r));
    });
  }
}
