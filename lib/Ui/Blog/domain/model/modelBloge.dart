class Blog {
  List<DataBlog>? data;

  Blog({this.data});

  Blog.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <DataBlog>[];
      json['data'].forEach((v) {
        data!.add(new DataBlog.fromJson(v));
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

class DataBlog {
  int? id;
  String? coverImage;
  List<String>? imagesBag;
  String? title;
  Null? metaTitle;
  String? metaDescription;
  Null? keywords;
  String? description;

  DataBlog(
      {this.id,
      this.coverImage,
      this.imagesBag,
      this.title,
      this.metaTitle,
      this.metaDescription,
      this.keywords,
      this.description});

  DataBlog.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    coverImage = json['cover_image'];
    imagesBag = json['images_bag'].cast<String>();
    title = json['title'];
    metaTitle = json['meta_title'];
    metaDescription = json['meta_description'];
    keywords = json['keywords'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['cover_image'] = this.coverImage;
    data['images_bag'] = this.imagesBag;
    data['title'] = this.title;
    data['meta_title'] = this.metaTitle;
    data['meta_description'] = this.metaDescription;
    data['keywords'] = this.keywords;
    data['description'] = this.description;
    return data;
  }
}
