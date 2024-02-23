import 'package:three_tapp_app/model/scrap_type.dart';

class Product {
  String id = '';
  String name = '';
  String image = '';
  String description = '';
  double mass = 0.0;
  double price = 0.0;
  String type = ScrapType.khac.toShortString();
  String uploadBy = '';
  String uploadDate = DateTime.now().toString();
  String editDate = DateTime.now().toString();

  Product({
    required this.id,
    required this.name,
    required this.image,
    required this.description,
    required this.mass,
    required this.price,
    required this.type,
    required this.uploadBy,
    required this.uploadDate,
    required this.editDate,
  });

  Product.empty() {
    id = '';
    name = '';
    image = '';
    description = '';
    price = 0.0;
    type = ScrapType.khac.toShortString(); //ket qua tra ve la "khac"
    uploadBy = '';
    mass = 0.0;
    uploadDate = DateTime.now().toString();
    editDate = DateTime.now().toString();
  }

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    description = json['description'];
    price = json['price'];
    type = json['type'];
    uploadBy = json['uploadBy'];
    mass = json['mass'];
    uploadDate = json['uploadDate'];
    editDate = json['editDate'];
  }
}
