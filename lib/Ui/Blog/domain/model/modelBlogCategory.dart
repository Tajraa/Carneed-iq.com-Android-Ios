class BlogModel {
  List<Data>? data;

  BlogModel({this.data});

  BlogModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? id;
  Null? parentId;
  List<String>? images;
  int? featured;
  int? status;
  int? sorting;
  String? slug;
  String? createdAt;
  String? updatedAt;
  String? coverImage;
  String? title;
  String? description;
  Null? parent;

  Data(
      {this.id,
      this.parentId,
      this.images,
      this.featured,
      this.status,
      this.sorting,
      this.slug,
      this.createdAt,
      this.updatedAt,
      this.coverImage,
      this.title,
      this.description,
      this.parent});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    parentId = json['parent_id'];
    images = json['images'].cast<String>();
    featured = json['featured'];
    status = json['status'];
    sorting = json['sorting'];
    slug = json['slug'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    coverImage = json['cover_image'];
    title = json['title'];
    description = json['description'];
    parent = json['parent'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['parent_id'] = this.parentId;
    data['images'] = this.images;
    data['featured'] = this.featured;
    data['status'] = this.status;
    data['sorting'] = this.sorting;
    data['slug'] = this.slug;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['cover_image'] = this.coverImage;
    data['title'] = this.title;
    data['description'] = this.description;
    data['parent'] = this.parent;
    return data;
  }
}
