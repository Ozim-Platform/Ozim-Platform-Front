import 'package:charity_app/model/user/user.dart';
import 'package:charity_app/utils/utils.dart';

class Data {
  int id;
  String name;
  String title;
  String description;
  String author;
  String authorPosition;
  ImageData authorPhoto;
  String category;
  ImageData image;
  int likes;
  int views;
  bool isPaid;
  bool isLiked;
  bool inBookmarks;
  List<DataComment> comments;
  num createdAt;
  String type;
  String bookmark_folder;
  DataUser user;
  num rating;
  bool rated;
  ImageData preview;
  String phone;
  String email;
  String link;
  BookInformation bookInformation;

  Data({
    this.id,
    this.name,
    this.title,
    this.description,
    this.author,
    this.authorPosition,
    this.authorPhoto,
    this.category,
    this.image,
    this.likes,
    this.views,
    this.isLiked,
    this.inBookmarks,
    this.comments,
    this.createdAt,
    this.type,
    this.isPaid,
    this.bookmark_folder,
    this.user,
    this.rating,
    this.rated,
    this.phone,
    this.email,
    this.link,
    this.bookInformation,
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = toInt(json['id']);
    name = json['name'];
    title = json['title'];
    description = json['description'];
    author = json['author'];
    authorPosition = json['author_position'];
    authorPhoto = (json['author_photo'] != null)
        ? ImageData.fromJson(json['author_photo'])
        : null;
    category = json['category'] == null
        ? null
        : json['category'] is String
            ? json['category']
            : json['category']['sys_name'];
    image = (json['image'] != null) ? ImageData.fromJson(json['image']) : null;
    likes = toInt(json['likes']);
    views = json['views'];
    isLiked = json['is_liked'];
    inBookmarks = json['in_bookmarks'];
    isPaid = (json["is_paid"] == null || json["is_paid"] == false)
        ? false
        : json["is_paid"];
    if (json['comments'] != null) {
      comments = <DataComment>[];
      json['comments'].forEach((v) {
        comments.add(new DataComment.fromJson(v));
      });
    } else {
      comments = <DataComment>[];
    }
    createdAt =
        json['created_at'] != null ? getTimestamp(json['created_at']) : null;
    type = json['type'];
    bookmark_folder =
        json['bookmark_folder'] != null ? json['bookmark_folder'] : null;
    user = json['user'] != null ? DataUser.fromJson(json['user']) : null;
    rating = json['rating'] != null ? json['rating'] : 0;
    rated = json['rated'] != null;
    preview =
        (json['preview'] != null) ? ImageData.fromJson(json['preview']) : null;
    phone = json['phone'] != null ? json['phone'] : null;
    email = json['email'] != null ? json['email'] : null;
    link = json['link'] != null ? json['link'] : null;
    bookInformation =
        json['book'] != null ? BookInformation.fromJson(json['book']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['title'] = this.title;
    data['description'] = this.description;
    data['author'] = this.author;
    data['author_position'] = this.authorPosition;
    data['author_photo'] =
        this.authorPhoto != null ? this.authorPhoto.toJson() : null;
    data['category'] = this.category;
    data['image'] = this.image != null ? this.image.toJson() : null;
    data['likes'] = this.likes;
    data['views'] = this.views;
    data['is_liked'] = this.isLiked;
    data['in_bookmarks'] = this.inBookmarks;
    if (this.comments != null) {
      data['comments'] = this.comments.map((v) => v.toJson()).toList();
    } else {
      data['comments'] = <DataComment>[];
    }
    data['created_at'] = this.createdAt;
    data['type'] = this.type;
    data['bookmark_folder'] = this.bookmark_folder;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    data['rated'] = this.rated;
    data['rating'] = this.rating;
    data['preview'] = this.preview != null ? this.preview.toJson() : null;
    data['phone'] = this.phone != null ? this.phone : null;
    data['email'] = this.email != null ? this.email : null;
    data['link'] = this.link != null ? this.link : null;
    return data;
  }

  @override
  String toString() {
    return 'Data{link: $link}';
  }
}

class ImageData {
  String id;
  String name;
  String path;
  String extension;

  ImageData({this.id, this.name, this.path, this.extension});

  ImageData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['original_name'];
    path = json['path'];
    extension = json['extension'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['original_name'] = this.name;
    data['path'] = this.path;
    data['extension'] = this.extension;
    return data;
  }
}

class DataComment {
  int id;
  String text;
  UserComment user;
  List<DataComment> replies;
  int repliesCount;
  num created_at;
  String instance;
  String instance_rus;
  String instance_id;

  DataComment(
      {this.id,
      this.text,
      this.user,
      this.replies,
      this.repliesCount,
      this.created_at,
      this.instance,
      this.instance_rus,
      this.instance_id});

  DataComment.fromJson(Map<String, dynamic> json) {
    id = toInt(json['id']);
    text = json['text'] != null ? json['text'] : '';
    user = json['user'] != null ? UserComment.fromJson(json['user']) : null;
    if (json['replies'] != null) {
      replies = <DataComment>[];
      json['replies'].forEach((v) {
        // print(v['replies'].toString());
        replies.add(new DataComment.fromJson(v));
      });
      replies = replies.reversed.toList();
    } else {
      replies = <DataComment>[];
    }
    repliesCount =
        json['repliesCount'] == null ? 0 : toInt(json['repliesCount']);
    created_at = json['created_at'] == null
        ? getTimestamp(DateTime.now().millisecondsSinceEpoch ~/ 1000)
        : getTimestamp(json['created_at']);
    instance = json['instance'];
    instance_rus = json['instance_rus'];
    instance_id =
        json['instance_id'] != null ? json['instance_id'].toString() : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['text'] = this.text;
    data['user'] = this.user != null ? this.user.toJson() : null;
    if (this.replies != null) {
      data['replies'] = this.replies.map((v) => v.toJson()).toList();
    } else {
      data['replies'] = <DataComment>[];
    }
    data['repliesCount'] = this.repliesCount;
    data['created_at'] = this.created_at;
    data['instance'] = this.instance;
    data['instance_rus'] = this.instance_rus;
    data['instance_id'] = this.instance_id;
    return data;
  }
}

class UserComment {
  int id;
  String phone;
  String name;
  String email;
  String avatar;

  UserComment({this.id, this.phone, this.name, this.email, this.avatar});

  UserComment.fromJson(Map<String, dynamic> json) {
    id = toInt(json['id']);
    phone = json['phone'] != null ? json['phone'] : null;
    name = json['name'] != null ? json['name'] : null;
    email = json['email'] != null ? json['email'] : null;
    avatar = json['avatar'] != null ? json['avatar'] : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['phone'] = this.phone != null ? this.phone : null;
    data['name'] = this.name != null ? this.name : null;
    data['email'] = this.email != null ? this.email : null;
    data['avatar'] = this.avatar != null ? this.avatar : null;
    return data;
  }
}

class BookInformation {
  String path;
  String extension;
  String originalName;

  BookInformation({this.path, this.extension, this.originalName});

  BookInformation.fromJson(Map<String, dynamic> json) {
    path = json['path'];
    extension = json['extension'];
    originalName = json['original_name'];
  }
}
