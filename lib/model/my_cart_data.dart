import 'dart:convert';

import '../woocommerce/models/product_variation.dart';
import '../woocommerce/models/products.dart';

class MyCartData{
  final String? image;
  final String? name;
  final String? Size;
  final String? price;
   int quantity;
  final int? id;

  MyCartData(
      this.image,
      this.name,
      this.Size,
      this.price,
      this.quantity,
      this.id);
}

List<CartOtherInfo> cartOtherInfoFromJson(String str) =>
    json.decode(str) == null
        ? []
        : List<CartOtherInfo>.from(
        json.decode(str)!.map((x) => CartOtherInfo.fromJson(x)));

String cartOtherInfoToJson(List<CartOtherInfo?>? data) => json.encode(
    data == null ? [] : List<dynamic>.from(data.map((x) => x!.toJson())));

class CartOtherInfo {
  CartOtherInfo({
    required this.variationId,
    required this.productId,
    required this.type,
    required this.productName,
    required this.productImage,
    required this.productPrice,
    required this.variationList,
    required this.quantity,
    required this.stockStatus,
    required this.taxClass,
  });

  int? variationId;
  int? productId;
  String? type;
  String? productName;
  String? productImage;
  double? productPrice;
  List<Attribute?>? variationList;
  int? quantity;
  String? stockStatus;
  final TaxClass taxClass;

  factory CartOtherInfo.fromJson(Map<String, dynamic> json) => CartOtherInfo(
    variationId: json["variationId"],
    productId: json["productId"],
    type: json["type"],
    productName: json["productName"],
    productImage: json["productImage"],
    productPrice: json["productPrice"],
    variationList: json["variationList"] == null
        ? []
        : List<Attribute?>.from(
        json["variationList"]!.map((x) => Attribute.fromJson(x))),
    quantity: json["quantity"],
    stockStatus: json["stockStatus"],
    taxClass: taxClassValues.map[json["tax_class"]]!,
  );

  Map<String, dynamic> toJson() => {
    "variationId": variationId,
    "productId": productId,
    "type": type,
    "productName": productName,
    "productImage": productImage,
    "productPrice": productPrice,
    "variationList": variationList == null
        ? []
        : List<dynamic>.from(variationList!.map((x) => x!.toJson())),
    "quantity": quantity,
    "stockStatus": stockStatus,
    "tax_class": taxClassValues.reverse[taxClass],

  };
}

// final taxClassValues = EnumValues({
//   "": TaxClass.EMPTY,
//   "reduced-rate": TaxClass.REDUCED_RATE
// });
//
// enum TaxClass { EMPTY, REDUCED_RATE }
//
//
// class EnumValues<T> {
//   Map<String, T> map;
//   late Map<T, String> reverseMap;
//
//   EnumValues(this.map);
//
//   Map<T, String> get reverse {
//     reverseMap = map.map((k, v) => MapEntry(v, k));
//     return reverseMap;
//   }
// }
