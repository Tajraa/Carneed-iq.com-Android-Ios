part of 'homesettings_bloc.dart';

@immutable
abstract class BlogEvent {}

class GetCategoryBlogs extends BlogEvent {}

class GetBlogs extends BlogEvent {
  final String categoryId;
  GetBlogs(this.categoryId);
}

class GetBlogdetails extends BlogEvent {
  final String Id;
  GetBlogdetails(this.Id);
}
