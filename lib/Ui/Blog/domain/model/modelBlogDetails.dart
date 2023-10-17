class DataBlogDetalse {
  int? id;
  String? coverImage;
  String? videoUrl;
  String? title;
  Null? metaTitle;
  String? metaDescription;
  String? link;
  Null? keywords;
  String? description;

  DataBlogDetalse(
      {this.id,
      this.coverImage,
      this.videoUrl,
      this.title,
      this.metaTitle,
      this.metaDescription,
      this.keywords,
      this.link,
      this.description});

  DataBlogDetalse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    coverImage = json['cover_image'];
    videoUrl = json['video_url'];
    title = json['title'];
    link = json["link"];
    metaTitle = json['meta_title'];
    metaDescription = json['meta_description'];
    keywords = json['keywords'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['cover_image'] = this.coverImage;
    data['video_url'] = this.videoUrl;
    data['title'] = this.title;
    data['link'] = this.link;
    data['meta_title'] = this.metaTitle;
    data['meta_description'] = this.metaDescription;
    data['keywords'] = this.keywords;
    data['description'] = this.description;
    return data;
  }
}
