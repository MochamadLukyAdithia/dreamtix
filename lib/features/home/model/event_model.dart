import 'dart:ffi';

class EventModel {
  int? id;
  String? title;
  String? description;
  String? image;
  double? price;
  int? stock;

  EventModel(
      {this.id,
      this.title,
      this.description,
      this.image,
      this.price,
      this.stock});

  EventModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    title = json["title"];
    description = json["description"];
    image = json["image"];
    price = json["price"];
    stock = json["stock"];
  }
}
