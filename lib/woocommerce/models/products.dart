// import 'package:flutter/foundation.dart';
//
// /*
//  * BSD 3-Clause License
//
//     Copyright (c) 2020, RAY OKAAH - MailTo: ray@flutterengineer.com, Twitter: Rayscode
//     All rights reserved.
//
//     Redistribution and use in source and binary forms, with or without
//     modification, are permitted provided that the following conditions are met:
//
//     1. Redistributions of source code must retain the above copyright notice, this
//     list of conditions and the following disclaimer.
//
//     2. Redistributions in binary form must reproduce the above copyright notice,
//     this list of conditions and the following disclaimer in the documentation
//     and/or other materials provided with the distribution.
//
//     3. Neither the name of the copyright holder nor the names of its
//     contributors may be used to endorse or promote products derived from
//     this software without specific prior written permission.
//
//     THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
//     AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
//     IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//     DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
//     FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
//     DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
//     SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
//     CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
//     OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
//     OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
//  */
//
// import 'product_category.dart';
//
// class WooProduct {
//   final int? id;
//   final String? name;
//   final String? slug;
//   final String? permalink;
//   final String? type;
//   final String? status;
//   final bool? featured;
//   final String? catalogVisibility;
//   final String? description;
//   final String? shortDescription;
//   final String? sku;
//   final String? price;
//   final String? regularPrice;
//   final String? salePrice;
//   final String? priceHtml;
//   final bool? onSale;
//   final bool? purchasable;
//   final int? totalSales;
//   final bool? virtual;
//   final bool? downloadable;
//   final List<WooProductDownload> downloads;
//   final int? downloadLimit;
//   final int? downloadExpiry;
//   final String? externalUrl;
//   final String? buttonText;
//   final String? taxStatus;
//   final String? taxClass;
//   final bool? manageStock;
//   final int? stockQuantity;
//   final String? stockStatus;
//   final String? backorders;
//   final bool? backordersAllowed;
//   final bool? backordered;
//   final bool? soldIndividually;
//   final String? weight;
//   final WooProductDimension dimensions;
//   final bool? shippingRequired;
//   final bool? shippingTaxable;
//   final String? shippingClass;
//   final int? shippingClassId;
//   final bool? reviewsAllowed;
//   final String? averageRating;
//   // ignore: non_constant_identifier_names
//   final String? date_created;
//   final int? ratingCount;
//   final List<int>? relatedIds;
//   final List<int>? upsellIds;
//   final List<int>? crossSellIds;
//   final int? parentId;
//   final String? purchaseNote;
//   final List<WooProductCategory> categories;
//   final List<WooProductItemTag> tags;
//   final List<WooProductImage> images;
//   final List<WooProductItemAttribute> attributes;
//   final List<WooProductDefaultAttribute> defaultAttributes;
//   final List<int>? variations;
//   final List<int>? groupedProducts;
//   final int? menuOrder;
//   final List<MetaData> metaData;
//
//   WooProduct(
//       this.id,
//       this.name,
//       this.slug,
//       this.permalink,
//       this.type,
//       this.status,
//       this.featured,
//       this.catalogVisibility,
//       this.description,
//       this.shortDescription,
//       this.sku,
//       this.price,
//       this.regularPrice,
//       this.salePrice,
//       this.priceHtml,
//       this.onSale,
//       this.purchasable,
//       this.totalSales,
//       this.virtual,
//       this.downloadable,
//       this.downloads,
//       this.downloadLimit,
//       this.downloadExpiry,
//       this.externalUrl,
//       this.buttonText,
//       this.taxStatus,
//       this.taxClass,
//       this.manageStock,
//       this.stockQuantity,
//       this.stockStatus,
//       this.backorders,
//       this.backordersAllowed,
//       this.backordered,
//       this.soldIndividually,
//       this.weight,
//       this.dimensions,
//       this.shippingRequired,
//       this.shippingTaxable,
//       this.shippingClass,
//       this.shippingClassId,
//       this.reviewsAllowed,
//       this.averageRating,
//       this.ratingCount,
//       this.relatedIds,
//       this.upsellIds,
//       this.crossSellIds,
//       this.parentId,
//       this.purchaseNote,
//       this.categories,
//       this.tags,
//       this.images,
//       this.attributes,
//       this.defaultAttributes,
//       this.variations,
//       this.groupedProducts,
//       this.menuOrder,
//       this.date_created,
//       this.metaData);
//
//   WooProduct.fromJson(Map<String, dynamic> json)
//       : id = json['id'],
//         name = json['name'],
//         slug = json['slug'],
//         permalink = json['permalink'],
//         type = json['type'],
//         status = json['status'],
//         featured = json['featured'],
//         catalogVisibility = json['catalog_visibility'],
//         description = json['description'],
//         shortDescription = json['short_description'],
//         sku = json['sku'],
//         price = json['price'],
//         regularPrice = json['regular_price'],
//         salePrice = json['sale_price'],
//         priceHtml = json['price_html'],
//         onSale = json['on_sale'],
//         purchasable = json['purchasable'],
//         totalSales = json['total_sales'],
//         virtual = json['virtual'],
//         downloadable = json['downloadable'],
//         downloads = (json['downloads'] as List)
//             .map((i) => WooProductDownload.fromJson(i))
//             .toList(),
//         downloadLimit = json['download_limit'],
//         downloadExpiry = json['download_expiry'],
//         externalUrl = json['external_url'],
//         buttonText = json['button_text'],
//         taxStatus = json['tax_status'],
//         taxClass = json['tax_class'],
//         manageStock = json['manage_stock'],
//         stockQuantity = json['stock_quantity'],
//         stockStatus = json['stock_status'],
//         backorders = json['backorders'],
//         backordersAllowed = json['backorders_allowed'],
//         backordered = json['backordered'],
//         soldIndividually = json['sold_individually'],
//         weight = json['weight'],
//         dimensions = WooProductDimension.fromJson(json['dimensions']),
//         shippingRequired = json['shipping_required'],
//         shippingTaxable = json['shipping_taxable'],
//         shippingClass = json['shipping_class'],
//         shippingClassId = json['shipping_class_id'],
//         reviewsAllowed = json['reviews_allowed'],
//         averageRating = json['average_rating'],
//         ratingCount = json['rating_count'],
//         relatedIds = json['related_ids'].cast<int>(),
//         upsellIds = json['upsell_ids'].cast<int>(),
//         crossSellIds = json['cross_sell_ids'].cast<int>(),
//         parentId = json['parent_id'],
//         purchaseNote = json['purchase_note'],
//         categories = (json['categories'] as List)
//             .map((i) => WooProductCategory.fromJson(i))
//             .toList(),
//         tags = (json['tags'] as List)
//             .map((i) => WooProductItemTag.fromJson(i))
//             .toList(),
//         images = (json['images'] as List)
//             .map((i) => WooProductImage.fromJson(i))
//             .toList(),
//         attributes = (json['attributes'] as List)
//             .map((i) => WooProductItemAttribute.fromJson(i))
//             .toList(),
//         defaultAttributes = (json['default_attributes'] as List)
//             .map((i) => WooProductDefaultAttribute.fromJson(i))
//             .toList(),
//         variations = json['variations'].cast<int>(),
//         groupedProducts = json['grouped_products'].cast<int>(),
//         menuOrder = json['menu_order'],
//         date_created = json['date_created'],
//         metaData = (json['meta_data'] as List)
//             .map((i) => MetaData.fromJson(i))
//             .toList();
//
//
//
//
//
//
//
//   @override
//   toString() => "{id: $id}, {name: $name}, {price: $price}, {status: $status}";
//
//   @override
//   bool operator ==(Object other) {
//     if (identical(this, other)) return true;
//
//     return other is WooProduct && other.id == id;
//   }
//
//   @override
//   int get hashCode {
//     return id.hashCode;
//   }
// }
//
// class WooProductItemTag {
//   final int? id;
//   final String? name;
//   final String? slug;
//
//   WooProductItemTag(this.id, this.name, this.slug);
//
//   WooProductItemTag.fromJson(Map<String, dynamic> json)
//       : id = json['id'],
//         name = json['name'],
//         slug = json['slug'];
//
//   Map<String, dynamic> toJson() => {'id': id, 'name': name, 'slug': slug};
//   @override
//   toString() => 'Tag: $name';
// }
//
// class MetaData {
//   final int? id;
//   final String? key;
//   final String value;
//
//   MetaData(this.id, this.key, this.value);
//
//   MetaData.fromJson(Map<String, dynamic> json)
//       : id = json['id'],
//         key = json['key'],
//         value = json['value'].toString();
//
//   Map<String, dynamic> toJson() => {'id': id, 'key': key, 'value': value};
// }
//
// class WooProductDefaultAttribute {
//   final int? id;
//   final String? name;
//   final String? option;
//
//   WooProductDefaultAttribute(this.id, this.name, this.option);
//
//   WooProductDefaultAttribute.fromJson(Map<String, dynamic> json)
//       : id = json['id'],
//         name = json['name'],
//         option = json['option'];
//
//   Map<String, dynamic> toJson() => {'id': id, 'name': name, 'option': option};
// }
//
// class WooProductImage {
//   final int? id;
//   final DateTime dateCreated;
//   final DateTime dateCreatedGMT;
//   final DateTime dateModified;
//   final DateTime dateModifiedGMT;
//   final String? src;
//   final String? name;
//   final String? alt;
//
//   WooProductImage(this.id, this.src, this.name, this.alt, this.dateCreated,
//       this.dateCreatedGMT, this.dateModified, this.dateModifiedGMT);
//
//   WooProductImage.fromJson(Map<String, dynamic> json)
//       : id = json['id'],
//         src = json['src'],
//         name = json['name'],
//         alt = json['alt'],
//         dateCreated = DateTime.parse(json['date_created']),
//         dateModifiedGMT = DateTime.parse(json['date_modified_gmt']),
//         dateModified = DateTime.parse(json['date_modified']),
//         dateCreatedGMT = DateTime.parse(json['date_created_gmt']);
// }
//
// ///
// /// class Category {
// ///  final int id;
// /// final String name;
// ///   final String slug;
//
// ///   Category(this.id, this.name, this.slug);
//
// ///   Category.fromJson(Map<String, dynamic> json)
// ///       : id = json['id'],
// ///         name = json['name'],
// ///         slug = json['slug'];
//
// ///   Map<String, dynamic> toJson() => {
// ///         'id': id,
// ///         'name': name,
// ///         'slug': slug,
// ///       };
// ///   @override toString() => toJson().toString();
// /// }
// ///
//
// class WooProductDimension {
//   final String? length;
//   final String? width;
//   final String? height;
//
//   WooProductDimension(this.length, this.height, this.width);
//
//   WooProductDimension.fromJson(Map<String, dynamic> json)
//       : length = json['length'],
//         width = json['width'],
//         height = json['height'];
//
//   Map<String, dynamic> toJson() =>
//       {'length': length, 'width': width, 'height': height};
// }
//
// class WooProductItemAttribute {
//   final int? id;
//   final String? name;
//   final int? position;
//   final bool? visible;
//   final bool? variation;
//   final List<String>? options;
//
//   WooProductItemAttribute(this.id, this.name, this.position, this.visible,
//       this.variation, this.options);
//
//   WooProductItemAttribute.fromJson(Map<String, dynamic> json)
//       : id = json['id'],
//         name = json['name'],
//         position = json['position'],
//         visible = json['visible'],
//         variation = json['variation'],
//         options = json['options'].cast<String>();
//
//   Map<String, dynamic> toJson() => {
//         'id': id,
//         'name': name,
//         'position': position,
//         'visible': visible,
//         'variation': variation,
//         'options': options,
//       };
// }
//
// class WooProductDownload {
//   final String? id;
//   final String? name;
//   final String? file;
//
//   WooProductDownload(this.id, this.name, this.file);
//
//   WooProductDownload.fromJson(Map<String, dynamic> json)
//       : id = json['id'],
//         name = json['name'],
//         file = json['file'];
//
//   Map<String, dynamic> toJson() => {
//         'id': id,
//         'name': name,
//         'file': file,
//       };
// }


// To parse this JSON data, do
//
//     final wooProduct = wooProductFromJson(jsonString);

import 'dart:convert';

List<WooProduct> wooProductFromJson(String str) => List<WooProduct>.from(json.decode(str).map((x) => WooProduct.fromJson(x)));

String wooProductToJson(List<WooProduct> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class WooProduct {
  final int id;
  final String name;
  final String slug;
  final String permalink;
  final DateTime dateCreated;
  final DateTime dateCreatedGmt;
  final DateTime dateModified;
  final DateTime dateModifiedGmt;
  // final Type type;
  final String? type;
  final Status status;
  final bool featured;
  final CatalogVisibility catalogVisibility;
  final String description;
  final String shortDescription;
  // final Sku sku;
  final String price;
  final String regularPrice;
  final String salePrice;
  final dynamic dateOnSaleFrom;
  final dynamic dateOnSaleFromGmt;
  final dynamic dateOnSaleTo;
  final dynamic dateOnSaleToGmt;
  final bool onSale;
  final bool purchasable;
  final dynamic totalSales;
  final bool virtual;
  final bool downloadable;
  final List<dynamic> downloads;
  final int downloadLimit;
  final int downloadExpiry;
  final String externalUrl;
  final String buttonText;
  final TaxStatus taxStatus;
  final TaxClass taxClass;
  final bool manageStock;
  final dynamic stockQuantity;
  final Backorders backorders;
  final bool backordersAllowed;
  final bool backordered;
  final dynamic lowStockAmount;
  final bool soldIndividually;
  final String weight;
  final Dimensions dimensions;
  final bool shippingRequired;
  final bool shippingTaxable;
  final String shippingClass;
  final int shippingClassId;
  final bool reviewsAllowed;
  final String averageRating;
  final int ratingCount;
  final List<int> upsellIds;
  final List<int> crossSellIds;
  final int parentId;
  final PurchaseNote purchaseNote;
  final List<Category> categories;
  final List<Category> tags;
  final List<WooProductImage> images;
  final List<WooProductItemAttribute> attributes;
  final List<dynamic> defaultAttributes;
  final List<int> variations;
  final List<dynamic> groupedProducts;
  final int menuOrder;
  final String priceHtml;
  final List<int> relatedIds;
  // final List<MetaDatum> metaData;
  // final StockStatus stockStatus;
  final String? stockStatus;
  final bool hasOptions;
  final Links links;

  WooProduct({
    required this.id,
    required this.name,
    required this.slug,
    required this.permalink,
    required this.dateCreated,
    required this.dateCreatedGmt,
    required this.dateModified,
    required this.dateModifiedGmt,
    required this.type,
    required this.status,
    required this.featured,
    required this.catalogVisibility,
    required this.description,
    required this.shortDescription,
    // required this.sku,
    required this.price,
    required this.regularPrice,
    required this.salePrice,
    required this.dateOnSaleFrom,
    required this.dateOnSaleFromGmt,
    required this.dateOnSaleTo,
    required this.dateOnSaleToGmt,
    required this.onSale,
    required this.purchasable,
    required this.totalSales,
    required this.virtual,
    required this.downloadable,
    required this.downloads,
    required this.downloadLimit,
    required this.downloadExpiry,
    required this.externalUrl,
    required this.buttonText,
    required this.taxStatus,
    required this.taxClass,
    required this.manageStock,
    required this.stockQuantity,
    required this.backorders,
    required this.backordersAllowed,
    required this.backordered,
    required this.lowStockAmount,
    required this.soldIndividually,
    required this.weight,
    required this.dimensions,
    required this.shippingRequired,
    required this.shippingTaxable,
    required this.shippingClass,
    required this.shippingClassId,
    required this.reviewsAllowed,
    required this.averageRating,
    required this.ratingCount,
    required this.upsellIds,
    required this.crossSellIds,
    required this.parentId,
    required this.purchaseNote,
    required this.categories,
    required this.tags,
    required this.images,
    required this.attributes,
    required this.defaultAttributes,
    required this.variations,
    required this.groupedProducts,
    required this.menuOrder,
    required this.priceHtml,
    required this.relatedIds,
    // required this.metaData,
    required this.stockStatus,
    required this.hasOptions,
    required this.links,
  });

  factory WooProduct.fromJson(dynamic json) => WooProduct(
    id: json["id"],
    name: json["name"],
    slug: json["slug"],
    permalink: json["permalink"],
    dateCreated: DateTime.parse(json["date_created"].toString()),
    dateCreatedGmt: DateTime.parse(json["date_created_gmt"]),
    dateModified: DateTime.parse(json["date_modified"]),
    dateModifiedGmt: DateTime.parse(json["date_modified_gmt"]),
    // type: typeValues.map[json["type"]]!,
    type : json['type'],
    status: statusValues.map[json["status"]]!,
    featured: json["featured"],
    catalogVisibility: catalogVisibilityValues.map[json["catalog_visibility"]]!,
    description: json["description"],
    shortDescription: json["short_description"],
    // sku: skuValues.map[json["sku"]]!,
    price: json["price"],
    regularPrice: json["regular_price"],
    salePrice: json["sale_price"],
    dateOnSaleFrom: json["date_on_sale_from"],
    dateOnSaleFromGmt: json["date_on_sale_from_gmt"],
    dateOnSaleTo: json["date_on_sale_to"],
    dateOnSaleToGmt: json["date_on_sale_to_gmt"],
    onSale: json["on_sale"],
    purchasable: json["purchasable"],
    totalSales: json["total_sales"],
    virtual: json["virtual"],
    downloadable: json["downloadable"],
    downloads: List<dynamic>.from(json["downloads"].map((x) => x)),
    downloadLimit: json["download_limit"],
    downloadExpiry: json["download_expiry"],
    externalUrl: json["external_url"],
    buttonText: json["button_text"],
    taxStatus: taxStatusValues.map[json["tax_status"]]!,
    taxClass: taxClassValues.map[json["tax_class"]]!,
    manageStock: json["manage_stock"],
    stockQuantity: json["stock_quantity"],
    backorders: backordersValues.map[json["backorders"]]!,
    backordersAllowed: json["backorders_allowed"],
    backordered: json["backordered"],
    lowStockAmount: json["low_stock_amount"],
    soldIndividually: json["sold_individually"],
    weight: json["weight"],
    dimensions: Dimensions.fromJson(json["dimensions"]),
    shippingRequired: json["shipping_required"],
    shippingTaxable: json["shipping_taxable"],
    shippingClass: json["shipping_class"],
    shippingClassId: json["shipping_class_id"],
    reviewsAllowed: json["reviews_allowed"],
    averageRating: json["average_rating"],
    ratingCount: json["rating_count"],
    upsellIds: List<int>.from(json["upsell_ids"].map((x) => x)),
    crossSellIds: List<int>.from(json["cross_sell_ids"].map((x) => x)),
    parentId: json["parent_id"],
    purchaseNote: purchaseNoteValues.map[json["purchase_note"]]!,
    categories: List<Category>.from(json["categories"].map((x) => Category.fromJson(x))),
    tags: List<Category>.from(json["tags"].map((x) => Category.fromJson(x))),
    images: List<WooProductImage>.from(json["images"].map((x) => WooProductImage.fromJson(x))),
    attributes: List<WooProductItemAttribute>.from(json["attributes"].map((x) => WooProductItemAttribute.fromJson(x))),
    defaultAttributes: List<dynamic>.from(json["default_attributes"].map((x) => x)),
    variations: List<int>.from(json["variations"].map((x) => x)),
    groupedProducts: List<dynamic>.from(json["grouped_products"].map((x) => x)),
    menuOrder: json["menu_order"],
    priceHtml: json["price_html"],
    relatedIds: List<int>.from(json["related_ids"].map((x) => x)),
    // metaData: List<MetaDatum>.from(json["meta_data"].map((x) => MetaDatum.fromJson(x))),
    // stockStatus: stockStatusValues.map[json["stock_status"]]!,
    stockStatus : json['stock_status'],
    hasOptions: json["has_options"],
    links: Links.fromJson(json["_links"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "slug": slug,
    "permalink": permalink,
    "date_created": dateCreated.toIso8601String(),
    "date_created_gmt": dateCreatedGmt.toIso8601String(),
    "date_modified": dateModified.toIso8601String(),
    "date_modified_gmt": dateModifiedGmt.toIso8601String(),
    "type": typeValues.reverse[type],
    "status": statusValues.reverse[status],
    "featured": featured,
    "catalog_visibility": catalogVisibilityValues.reverse[catalogVisibility],
    "description": description,
    "short_description": shortDescription,
    // "sku": skuValues.reverse[sku],
    "price": price,
    "regular_price": regularPrice,
    "sale_price": salePrice,
    "date_on_sale_from": dateOnSaleFrom,
    "date_on_sale_from_gmt": dateOnSaleFromGmt,
    "date_on_sale_to": dateOnSaleTo,
    "date_on_sale_to_gmt": dateOnSaleToGmt,
    "on_sale": onSale,
    "purchasable": purchasable,
    "total_sales": totalSales,
    "virtual": virtual,
    "downloadable": downloadable,
    "downloads": List<dynamic>.from(downloads.map((x) => x)),
    "download_limit": downloadLimit,
    "download_expiry": downloadExpiry,
    "external_url": externalUrl,
    "button_text": buttonText,
    "tax_status": taxStatusValues.reverse[taxStatus],
    "tax_class": taxClassValues.reverse[taxClass],
    "manage_stock": manageStock,
    "stock_quantity": stockQuantity,
    "backorders": backordersValues.reverse[backorders],
    "backorders_allowed": backordersAllowed,
    "backordered": backordered,
    "low_stock_amount": lowStockAmount,
    "sold_individually": soldIndividually,
    "weight": weight,
    "dimensions": dimensions.toJson(),
    "shipping_required": shippingRequired,
    "shipping_taxable": shippingTaxable,
    "shipping_class": shippingClass,
    "shipping_class_id": shippingClassId,
    "reviews_allowed": reviewsAllowed,
    "average_rating": averageRating,
    "rating_count": ratingCount,
    "upsell_ids": List<dynamic>.from(upsellIds.map((x) => x)),
    "cross_sell_ids": List<dynamic>.from(crossSellIds.map((x) => x)),
    "parent_id": parentId,
    "purchase_note": purchaseNoteValues.reverse[purchaseNote],
    "categories": List<dynamic>.from(categories.map((x) => x.toJson())),
    "tags": List<dynamic>.from(tags.map((x) => x.toJson())),
    "images": List<dynamic>.from(images.map((x) => x.toJson())),
    "attributes": List<dynamic>.from(attributes.map((x) => x.toJson())),
    "default_attributes": List<dynamic>.from(defaultAttributes.map((x) => x)),
    "variations": List<dynamic>.from(variations.map((x) => x)),
    "grouped_products": List<dynamic>.from(groupedProducts.map((x) => x)),
    "menu_order": menuOrder,
    "price_html": priceHtml,
    "related_ids": List<dynamic>.from(relatedIds.map((x) => x)),
    // "meta_data": List<dynamic>.from(metaData.map((x) => x.toJson())),
    "stock_status": stockStatusValues.reverse[stockStatus],
    "has_options": hasOptions,
    "_links": links.toJson(),
  };
}

class WooProductItemAttribute {
  final int id;
  final String name;
  final int position;
  final bool visible;
  final bool variation;
  final List<String> options;

  WooProductItemAttribute({
    required this.id,
    required this.name,
    required this.position,
    required this.visible,
    required this.variation,
    required this.options,
  });

  factory WooProductItemAttribute.fromJson(Map<String, dynamic> json) => WooProductItemAttribute(
    id: json["id"],
    name: json["name"],
    position: json["position"],
    visible: json["visible"],
    variation: json["variation"],
    options: List<String>.from(json["options"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "position": position,
    "visible": visible,
    "variation": variation,
    "options": List<dynamic>.from(options.map((x) => x)),
  };
}

enum Backorders { NO }

final backordersValues = EnumValues({
  "no": Backorders.NO
});

enum CatalogVisibility { VISIBLE }

final catalogVisibilityValues = EnumValues({
  "visible": CatalogVisibility.VISIBLE
});

class Category {
  final int id;
  final String name;
  final String slug;

  Category({
    required this.id,
    required this.name,
    required this.slug,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    id: json["id"],
    name: json["name"],
    slug: json["slug"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "slug": slug,
  };
}

class Dimensions {
  final String length;
  final String width;
  final String height;

  Dimensions({
    required this.length,
    required this.width,
    required this.height,
  });

  factory Dimensions.fromJson(Map<String, dynamic> json) => Dimensions(
    length: json["length"],
    width: json["width"],
    height: json["height"],
  );

  Map<String, dynamic> toJson() => {
    "length": length,
    "width": width,
    "height": height,
  };
}

class WooProductImage {
  final int id;
  final DateTime dateCreated;
  final DateTime dateCreatedGmt;
  final DateTime dateModified;
  final DateTime dateModifiedGmt;
  final String src;
  final String name;
  final Alt? alt;

  WooProductImage({
    required this.id,
    required this.dateCreated,
    required this.dateCreatedGmt,
    required this.dateModified,
    required this.dateModifiedGmt,
    required this.src,
    required this.name,
    this.alt,
  });

  factory WooProductImage.fromJson(Map<String, dynamic> json) => WooProductImage(
    id: json["id"],
    dateCreated: DateTime.parse(json["date_created"]),
    dateCreatedGmt: DateTime.parse(json["date_created_gmt"]),
    dateModified: DateTime.parse(json["date_modified"]),
    dateModifiedGmt: DateTime.parse(json["date_modified_gmt"]),
    src: json["src"],
    name: json["name"],
    alt: altValues.map[json["alt"]],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "date_created": dateCreated.toIso8601String(),
    "date_created_gmt": dateCreatedGmt.toIso8601String(),
    "date_modified": dateModified.toIso8601String(),
    "date_modified_gmt": dateModifiedGmt.toIso8601String(),
    "src": src,
    "name": name,
    "alt": altValues.reverse[alt] ?? "",
  };
}

enum Alt { WATERMELON_MONEY_PLANT, EMPTY, ASTRONAUT_MONEY_PLANT, BOTTLE_SANSEVIERIA_LOTUS_PLANT, BOTTLE_SANSEVIERIA_LOTUS_PLANT_1 }

final altValues = EnumValues({
  "Astronaut Money Plant": Alt.ASTRONAUT_MONEY_PLANT,
  "Bottle Sansevieria Lotus Plant": Alt.BOTTLE_SANSEVIERIA_LOTUS_PLANT,
  "Bottle Sansevieria Lotus Plant 1": Alt.BOTTLE_SANSEVIERIA_LOTUS_PLANT_1,
  "": Alt.EMPTY,
  "Watermelon Money Plant": Alt.WATERMELON_MONEY_PLANT
});

class Links {
  final List<Collection> self;
  final List<Collection> collection;

  Links({
    required this.self,
    required this.collection,
  });

  factory Links.fromJson(Map<String, dynamic> json) => Links(
    self: List<Collection>.from(json["self"].map((x) => Collection.fromJson(x))),
    collection: List<Collection>.from(json["collection"].map((x) => Collection.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "self": List<dynamic>.from(self.map((x) => x.toJson())),
    "collection": List<dynamic>.from(collection.map((x) => x.toJson())),
  };
}

class Collection {
  final String href;

  Collection({
    required this.href,
  });

  factory Collection.fromJson(Map<String, dynamic> json) => Collection(
    href: json["href"],
  );

  Map<String, dynamic> toJson() => {
    "href": href,
  };
}

class MetaDatum {
  final int id;
  final Key1 key;
  final Value value;

  MetaDatum({
    required this.id,
    required this.key,
    required this.value,
  });

  factory MetaDatum.fromJson(Map<String, dynamic> json) => MetaDatum(
    id: json["id"],
    key: keyValues.map[json["key"]]!,
    value: valueValues.map[json["value"]]!,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "key": keyValues.reverse[key],
    "value": valueValues.reverse[value],
  };
}

enum Key1 { SITE_SIDEBAR_LAYOUT, SITE_CONTENT_LAYOUT, THEME_TRANSPARENT_HEADER_META }

final keyValues = EnumValues({
  "site-content-layout": Key1.SITE_CONTENT_LAYOUT,
  "site-sidebar-layout": Key1.SITE_SIDEBAR_LAYOUT,
  "theme-transparent-header-meta": Key1.THEME_TRANSPARENT_HEADER_META
});

enum Value { DEFAULT }

final valueValues = EnumValues({
  "default": Value.DEFAULT
});

enum PurchaseNote { EMPTY, P_YOU_WILL_GET_THIS_AT_FIRST_MAY_P }

final purchaseNoteValues = EnumValues({
  "": PurchaseNote.EMPTY,
  "<p>you will get this at first may</p>\n": PurchaseNote.P_YOU_WILL_GET_THIS_AT_FIRST_MAY_P
});

enum Sku { EMPTY, THE_9964967_PL }

final skuValues = EnumValues({
  "": Sku.EMPTY,
  "9964967PL": Sku.THE_9964967_PL
});

enum Status { AUTO_DRAFT, PUBLISH }

final statusValues = EnumValues({
  "auto-draft": Status.AUTO_DRAFT,
  "publish": Status.PUBLISH
});

enum StockStatus { INSTOCK, OUTOFSTOCK }

final stockStatusValues = EnumValues({
  "instock": StockStatus.INSTOCK,
  "outofstock": StockStatus.OUTOFSTOCK
});

enum TaxClass { EMPTY, REDUCED_RATE ,STANDARD}

final taxClassValues = EnumValues({
  "": TaxClass.EMPTY,
  "reduced-rate": TaxClass.REDUCED_RATE,
});

enum TaxStatus { TAXABLE }

final taxStatusValues = EnumValues({
  "taxable": TaxStatus.TAXABLE
});

enum Type { SIMPLE, VARIABLE }

final typeValues = EnumValues({
  "simple": Type.SIMPLE,
  "variable": Type.VARIABLE
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
