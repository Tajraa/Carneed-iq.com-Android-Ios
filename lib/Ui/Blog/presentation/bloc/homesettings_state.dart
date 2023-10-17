part of 'homesettings_bloc.dart';

@immutable
abstract class BlogState {}

class BlogInitial extends BlogState {}

class CategoryBlogReady extends BlogState {
  List<Data> categorys = [];
  CategoryBlogReady(this.categorys);
}

class BlogReady extends BlogState {
  List<DataBlog> blogs = [];
  BlogReady(this.blogs);
}

class BlogDetReady extends BlogState {
  DataBlogDetalse blogs;
  BlogDetReady(this.blogs);
}

class BlogError extends BlogState {
  late final String error;
  BlogError(this.error);
}

class LoadingSettings extends BlogState {}
