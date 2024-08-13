import 'dart:convert';


// List<ModelShippingMethod> modelShippingMethodFromJson(String str) => List<ModelShippingMethod>.from(json.decode(str).map((x) => ModelShippingMethod.fromJson(x)));
//
// String modelShippingMethodToJson(List<ModelShippingMethod> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
//
// class ModelShippingMethod {
//   ModelShippingMethod({
//     this.id,
//     this.instanceId,
//     this.title,
//     this.order,
//     this.enabled,
//     this.methodId,
//     this.methodTitle,
//     this.methodDescription,
//     this.settings,
//     this.links,
//   });
//
//   int? id;
//   int? instanceId;
//   String? title;
//   int? order;
//   bool? enabled;
//   String? methodId;
//   String? methodTitle;
//   String? methodDescription;
//   Settings? settings;
//   Links? links;
//
//   factory ModelShippingMethod.fromJson(Map<String, dynamic> json) => ModelShippingMethod(
//     id: json["id"],
//     instanceId: json["instance_id"],
//     title: json["title"],
//     order: json["order"],
//     enabled: json["enabled"],
//     methodId: json["method_id"],
//     methodTitle: json["method_title"],
//     methodDescription: json["method_description"],
//     settings: Settings.fromJson(json["settings"]),
//     links: Links.fromJson(json["_links"]),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "instance_id": instanceId,
//     "title": title,
//     "order": order,
//     "enabled": enabled,
//     "method_id": methodId,
//     "method_title": methodTitle,
//     "method_description": methodDescription,
//     "settings": settings!.toJson(),
//     "_links": links!.toJson(),
//   };
// }
//
// class Links {
//   Links({
//     this.self,
//     this.collection,
//     this.describes,
//   });
//
//   List<Collection>? self;
//   List<Collection>? collection;
//   List<Collection>? describes;
//
//   factory Links.fromJson(Map<String, dynamic> json) => Links(
//     self: List<Collection>.from(json["self"].map((x) => Collection.fromJson(x))),
//     collection: List<Collection>.from(json["collection"].map((x) => Collection.fromJson(x))),
//     describes: List<Collection>.from(json["describes"].map((x) => Collection.fromJson(x))),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "self": List<dynamic>.from(self!.map((x) => x.toJson())),
//     "collection": List<dynamic>.from(collection!.map((x) => x.toJson())),
//     "describes": List<dynamic>.from(describes!.map((x) => x.toJson())),
//   };
// }
//
// class Collection {
//   Collection({
//     this.href,
//   });
//
//   String? href;
//
//   factory Collection.fromJson(Map<String, dynamic> json) => Collection(
//     href: json["href"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "href": href,
//   };
// }
//
// class Settings {
//   Settings({
//     this.title,
//     this.taxStatus,
//     this.cost,
//   });
//
//   Cost? title;
//   Cost? taxStatus;
//   Cost? cost;
//
//   factory Settings.fromJson(Map<String, dynamic> json) => Settings(
//     title: Cost.fromJson(json["title"]),
//     taxStatus: Cost.fromJson(json["tax_status"]),
//     cost: Cost.fromJson(json["cost"]),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "title": title!.toJson(),
//     "tax_status": taxStatus!.toJson(),
//     "cost": cost!.toJson(),
//   };
// }
//
// class Cost {
//   Cost({
//     this.id,
//     this.label,
//     this.description,
//     this.type,
//     this.value,
//     this.costDefault,
//     this.tip,
//     this.placeholder,
//     this.options,
//   });
//
//   String? id;
//   String? label;
//   String? description;
//   String? type;
//   String? value;
//   String? costDefault;
//   String? tip;
//   String? placeholder;
//   Options? options;
//
//   factory Cost.fromJson(Map<String, dynamic> json) => Cost(
//     id: json["id"],
//     label: json["label"],
//     description: json["description"],
//     type: json["type"],
//     value: json["value"],
//     costDefault: json["default"],
//     tip: json["tip"],
//     placeholder: json["placeholder"],
//     options: json["options"] == null ? null : Options.fromJson(json["options"]),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "label": label,
//     "description": description,
//     "type": type,
//     "value": value,
//     "default": costDefault,
//     "tip": tip,
//     "placeholder": placeholder,
//     "options": options == null ? null : options!.toJson(),
//   };
// }
//
// class Options {
//   Options({
//     this.taxable,
//     this.none,
//   });
//
//   String? taxable;
//   String? none;
//
//   factory Options.fromJson(Map<String, dynamic> json) => Options(
//     taxable: json["taxable"],
//     none: json["none"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "taxable": taxable,
//     "none": none,
//   };
// }


List<ModelShippingMethod?>? modelShippingMethodFromJson(String str) =>
    json.decode(str) == null ? [] : List<ModelShippingMethod?>.from(
        json.decode(str)!.map((x) => ModelShippingMethod.fromJson(x)));

String modelShippingMethodToJson(List<ModelShippingMethod?>? data) =>
    json.encode(
        data == null ? [] : List<dynamic>.from(data.map((x) => x!.toJson())));

class ModelShippingMethod {
  ModelShippingMethod({
    required this.id,
    required this.instanceId,
    required this.title,
    required this.order,
    required this.enabled,
    required this.methodId,
    required this.methodTitle,
    required this.methodDescription,
    required this.settings,
    required this.links,
  });

  final int? id;
  final int? instanceId;
  final String? title;
  final int? order;
  final bool? enabled;
  final String? methodId;
  final String? methodTitle;
  final String? methodDescription;
  final Settings? settings;
  final Links? links;

  factory ModelShippingMethod.fromJson(Map<String, dynamic> json) =>
      ModelShippingMethod(
        id: json["id"],
        instanceId: json["instance_id"],
        title: json["title"],
        order: json["order"],
        enabled: json["enabled"],
        methodId: json["method_id"],
        methodTitle: json["method_title"],
        methodDescription: json["method_description"],
        settings: Settings.fromJson(json["settings"]),
        links: Links.fromJson(json["_links"]),
      );

  Map<String, dynamic> toJson() =>
      {
        "id": id,
        "instance_id": instanceId,
        "title": title,
        "order": order,
        "enabled": enabled,
        "method_id": methodId,
        "method_title": methodTitle,
        "method_description": methodDescription,
        "settings": settings!.toJson(),
        "_links": links!.toJson(),
      };
}

class Links {
  Links({
    required this.self,
    required this.collection,
    required this.describes,
  });

  final List<Collection?>? self;
  final List<Collection?>? collection;
  final List<Collection?>? describes;

  factory Links.fromJson(Map<String, dynamic> json) =>
      Links(
        self: json["self"] == null ? [] : List<Collection?>.from(
            json["self"]!.map((x) => Collection.fromJson(x))),
        collection: json["collection"] == null ? [] : List<Collection?>.from(
            json["collection"]!.map((x) => Collection.fromJson(x))),
        describes: json["describes"] == null ? [] : List<Collection?>.from(
            json["describes"]!.map((x) => Collection.fromJson(x))),
      );

  Map<String, dynamic> toJson() =>
      {
        "self": self == null ? [] : List<dynamic>.from(
            self!.map((x) => x!.toJson())),
        "collection": collection == null ? [] : List<dynamic>.from(
            collection!.map((x) => x!.toJson())),
        "describes": describes == null ? [] : List<dynamic>.from(
            describes!.map((x) => x!.toJson())),
      };
}

class Collection {
  Collection({
    required this.href,
  });

  final String? href;

  factory Collection.fromJson(Map<String, dynamic> json) =>
      Collection(
        href: json["href"],
      );

  Map<String, dynamic> toJson() =>
      {
        "href": href,
      };
}

class Settings {
  Settings({
    required this.title,
    required this.taxStatus,
    required this.cost,
    required this.minAmount,
  });

  final Cost? title;
  final Cost? taxStatus;
  final Cost? cost;
  final IgnoreDiscounts? minAmount;

  factory Settings.fromJson(Map<String, dynamic> json)
  {
    return Settings(
      title:json["title"] == null ? null  : Cost.fromJson(json["title"]),
      taxStatus:json["tax_status"] == null ? null  : Cost.fromJson(json["tax_status"]),
      cost: json["cost"] == null ? null : Cost.fromJson(json["cost"]),
      minAmount: json["min_amount"] == null ? null : IgnoreDiscounts.fromJson(json["min_amount"]),
    );
  }

  Map<String, dynamic> toJson() =>
      {
        "title": title!.toJson(),
        "tax_status": taxStatus!.toJson(),
        "cost": cost!.toJson(),
        "min_amount": minAmount!.toJson(),
      };
}

class Cost {
  Cost({
    required this.id,
    required this.label,
    required this.description,
    required this.type,
    required this.value,
    required this.costDefault,
    required this.tip,
    required this.placeholder,
    required this.options,
  });

  final String? id;
  final String? label;
  final String? description;
  final String? type;
  final String? value;
  final String? costDefault;
  final String? tip;
  final String? placeholder;
  final Options? options;

  factory Cost.fromJson(Map<String, dynamic> json) =>
      Cost(
        id: json["id"] ,
        label: json["label"],
        description: json["description"] ,
        type: json["type"],
        value: json["value"] ,
        costDefault: json["default"] ,
        tip: json["tip"] ,
        placeholder: json["placeholder"],
        options: json["options"] == null ? null : Options.fromJson(
            json["options"]),
      );

  Map<String, dynamic> toJson() =>
      {
        "id": id,
        "label": label,
        "description": description,
        "type": type,
        "value": value,
        "default": costDefault,
        "tip": tip,
        "placeholder": placeholder,
        "options": options == null ? null : options!.toJson(),
      };
}

class Options {
  Options({
    required this.taxable,
    required this.none,
  });

  final String? taxable;
  final String? none;

  factory Options.fromJson(Map<String, dynamic> json) =>
      Options(
        taxable: json["taxable"],
        none: json["none"],
      );

  Map<String, dynamic> toJson() =>
      {
        "taxable": taxable,
        "none": none,
      };
}


class SettingsFree {
  SettingsFree({
    required this.title,
    required this.requires,
    required this.minAmount,
    required this.ignoreDiscounts,
  });

  final IgnoreDiscounts? title;
  final IgnoreDiscounts? requires;
  final IgnoreDiscounts? minAmount;
  final IgnoreDiscounts? ignoreDiscounts;

  factory SettingsFree.fromJson(Map<String, dynamic> json) =>
      SettingsFree(
        title: IgnoreDiscounts.fromJson(json["title"]),
        requires: IgnoreDiscounts.fromJson(json["requires"]),
        minAmount: IgnoreDiscounts.fromJson(json["min_amount"]),
        ignoreDiscounts: IgnoreDiscounts.fromJson(json["ignore_discounts"]),
      );

  Map<String, dynamic> toJson() =>
      {
        "title": title!.toJson(),
        "requires": requires!.toJson(),
        "min_amount": minAmount!.toJson(),
        "ignore_discounts": ignoreDiscounts!.toJson(),
      };
}

class IgnoreDiscounts {
  IgnoreDiscounts({
    required this.id,
    required this.label,
    required this.description,
    required this.type,
    required this.value,
    required this.ignoreDiscountsDefault,
    required this.tip,
    required this.placeholder,
    required this.options,
  });

  final String? id;
  final String? label;
  final String? description;
  final String? type;
  final String? value;
  final String? ignoreDiscountsDefault;
  final String? tip;
  final String? placeholder;
  final OptionsFree? options;

  factory IgnoreDiscounts.fromJson(Map<String, dynamic> json) =>
      IgnoreDiscounts(
        id: json["id"],
        label: json["label"],
        description: json["description"],
        type: json["type"],
        value: json["value"],
        ignoreDiscountsDefault: json["default"],
        tip: json["tip"],
        placeholder: json["placeholder"],
        options: json["options"] == null ? null : OptionsFree.fromJson(
            json["options"]),
      );

  Map<String, dynamic> toJson() =>
      {
        "id": id,
        "label": label,
        "description": description,
        "type": type,
        "value": value,
        "default": ignoreDiscountsDefault,
        "tip": tip,
        "placeholder": placeholder,
        "options": options == null ? null : options!.toJson(),
      };
}

class OptionsFree {
  OptionsFree({
    required this.empty,
    required this.coupon,
    required this.minAmount,
    required this.either,
    required this.both,
  });

  final String? empty;
  final String? coupon;
  final String? minAmount;
  final String? either;
  final String? both;

  factory OptionsFree.fromJson(Map<String, dynamic> json) =>
      OptionsFree(
        empty: json[""],
        coupon: json["coupon"],
        minAmount: json["min_amount"],
        either: json["either"],
        both: json["both"],
      );

  Map<String, dynamic> toJson() =>
      {
        "": empty,
        "coupon": coupon,
        "min_amount": minAmount,
        "either": either,
        "both": both,
      };
}
