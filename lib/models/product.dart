import 'package:get/get.dart';
import 'dart:convert';

List<Product> productFromJson(String str) => List<Product>.from(json.decode(str).map((x) => Product.fromJson(x)));

String productToJson(List<Product> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Product {
  Product({
    required this.id,
    required this.brand,
    required this.name,
    required this.price,
    required this.priceSign,
    required this.currency,
    required this.imageLink,
    required this.productLink,
    required this.description,
    required this.productType,
    required this.productColors,
  });

  final int id;
  final String brand;
  final String name;
  double price;
  String priceSign;
  String currency;
  final String imageLink;
  final String productLink;
  final String description;
  final String productType;
  final List<ProductColor> productColors;

  var isFavorite = false.obs;
  var commentFav="";
  var displayedCurrency = "\$".obs;
  var coefficient = 1.0;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json["id"],
    brand: json["brand"],
    name: json["name"].replaceAll("<BR>"," "),
    price: json["price"] == null ? 0.0 : double.parse(json["price"].toString()),
    priceSign: json["price_sign"]== null ? "\$" : json["price_sign"],
    currency: json["currency"]== null ? "USD" : json["currency"],
    imageLink: json["image_link"],
    productLink: json["product_link"],
    description: json["description"]== null ? "-" : json["description"],
    productType: json["product_type"].replaceAll("_"," "),
    productColors: List<ProductColor>.from(json["product_colors"].map((x) => ProductColor.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "brand": brand,
    "name": name,
    "price": price,
    "price_sign": priceSign,
    "currency": currency,
    "image_link": imageLink,
    "product_link": productLink,
    "description": description,
    "product_type": productType,
    "product_colors": List<dynamic>.from(productColors.map((x) => x.toJson())),
  };
}

class ProductColor {
  ProductColor({
    required this.hexValue,
    
    required this.colourName,
  });

  final String hexValue;
  final String colourName;

  factory ProductColor.fromJson(Map<String, dynamic> json) => ProductColor(
    hexValue: json["hex_value"].substring(0,7),
    colourName: json["colour_name"]== null ? "-" : json["colour_name"],
  );

  Map<String, dynamic> toJson() => {
    "hex_value": hexValue,
    "colour_name": colourName,
  };
}
