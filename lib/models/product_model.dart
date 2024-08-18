import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  String? id;
  String? name;
  String? category;
  num? price;
  String? imageName;
  String? localImagePath;
  String? downlodeImageUrl;
  String? description;
  int stock;
  bool isAvailable;
  Timestamp? purchaseDate;
  ProductModel(
      {this.id,
      this.name,
      this.category,
      this.price,
      this.imageName,
      this.localImagePath,
      this.downlodeImageUrl,
      this.description,
      this.stock = 1,
      this.isAvailable = true,
      this.purchaseDate});
  // ignore: non_constant_identifier_names
  Map<String, dynamic> ToMap() {
    var map = <String, dynamic>{
      'id': id,
      'name': name,
      'category': category,
      'price': price,
      'imageName': imageName,
      'localImagePath': localImagePath,
      'downlodeImageUrl': downlodeImageUrl,
      'description': description,
      'stock': stock,
      'isAvailable': isAvailable,
      'purchaseDate': purchaseDate,
    };
    return map;
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) => ProductModel(
        id: map['id'],
        name: map['name'],
        category: map['category'],
        price: map['price'],
        imageName: map['imageName'],
        localImagePath: map['localImagePath'],
        downlodeImageUrl: map['downlodeImageUrl'],
        description: map['description'],
        stock: map['stock'],
        isAvailable: map['isAvailable'],
        purchaseDate: map['purchaseDate'],
      );
  @override
  String toString() {
    return 'ProductModel{id:$id,name:$name,category:$category,price:$price, imageName:$imageName,localImagePath:$localImagePath,downlodeImageUrl:$downlodeImageUrl,description:$description,stock:$stock,isAvailable:$isAvailable,purchaseDate:$purchaseDate}';
  }
}
