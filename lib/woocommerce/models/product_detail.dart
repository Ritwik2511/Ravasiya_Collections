import 'dart:convert';

import 'package:ravasiya_collections/woocommerce/models/products.dart';

ProductDetailModel productDetailModelFromJson(String str) =>
    ProductDetailModel.fromJson(json.decode(str));

String productDetailModelToJson(ProductDetailModel data) =>
    json.encode(data.toJson());

class ProductDetailModel {
  ProductDetailModel({
    required this.id,
    required this.stockStatus,
    required this.taxClass,
  });

  final int id;
  final String stockStatus;
  final TaxClass taxClass;

  factory ProductDetailModel.fromJson(Map<String, dynamic> json) =>
      ProductDetailModel(
        id: json["id"],
        stockStatus: json["stock_status"] as String,
        taxClass: json["tax_class"],
      );

  Map<String, dynamic> toJson() =>
      {"id": id, "stock_status": stockStatus, "tax_class": taxClass};
}
