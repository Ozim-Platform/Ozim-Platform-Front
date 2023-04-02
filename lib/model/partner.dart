import 'package:charity_app/model/data.dart';

class PartnerData {
  List<Partner> data;
  int page;
  int pages;

  PartnerData({this.data, this.page, this.pages});

  factory PartnerData.fromJson(Map<String, dynamic> json) {
    var dataList = json['data'] as List;

    List<Partner> items = [];

    dataList.forEach((i) => items.add(Partner.fromJson(i)));
    return PartnerData(
      data: items,
      page: json['page'],
      pages: json['pages'],
    );
  }
}

class Partner {
  int id;
  String name;
  String title;
  // bool isPaid;
  String description;
  int price;
  ImageData image;
  List<ImageData> images;
  bool exchangedPoints;
  Partner({
    this.id,
    this.name,
    this.title,
    // this.isPaid,
    this.description,
    this.price,
    this.image,
    this.images,
    this.exchangedPoints,
  });

  factory Partner.fromJson(Map<String, dynamic> json) {
    var imageJson = json['image'] as Map<String, dynamic>;
    var imagesJson = json['images'] as List;
    List<ImageData> imageList = [];
    if (json['images'] == null) {
      imageList = [];
    } else {
      imagesJson.map(
        (i) => imageList.add(
          ImageData.fromJson(i),
        ),
      );
    }

    return Partner(
      id: json['id'],
      name: json['name'],
      title: json['title'],
      // isPaid: json['is_paid'],
      description: json['description'],
      price: json['price'],
      image: ImageData.fromJson(imageJson),
      images: imageList,
      exchangedPoints: json["is_changed"],
    );
  }
}
