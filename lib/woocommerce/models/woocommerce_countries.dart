
class Country {
  String? code;
  String? name;
  List<States>? states;
  // Links? links;

  Country({
    this.code,
    this.name,
    this.states,
    // this.links,
  });

  factory Country.fromJson(Map<String, dynamic> json) => Country(
    code: json["code"],
    name: json["name"],
    states: json["states"] == null ? [] : List<States>.from(json["states"]!.map((x) => States.fromJson(x))),
    // links: json["_links"] == null ? null : Links.fromJson(json["_links"]),
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "name": name,
    "states": states == null ? [] : List<dynamic>.from(states!.map((x) => x.toJson())),
    // "_links": links?.toJson(),
  };
}

// class Links {
//   List<Collection>? self;
//   List<Collection>? collection;
//
//   Links({
//     this.self,
//     this.collection,
//   });
//
//   factory Links.fromJson(Map<String, dynamic> json) => Links(
//     self: json["self"] == null ? [] : List<Collection>.from(json["self"]!.map((x) => Collection.fromJson(x))),
//     collection: json["collection"] == null ? [] : List<Collection>.from(json["collection"]!.map((x) => Collection.fromJson(x))),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "self": self == null ? [] : List<dynamic>.from(self!.map((x) => x.toJson())),
//     "collection": collection == null ? [] : List<dynamic>.from(collection!.map((x) => x.toJson())),
//   };
// }

// class Collection {
//   String? href;
//
//   Collection({
//     this.href,
//   });
//
//   factory Collection.fromJson(Map<String, dynamic> json) => Collection(
//     href: json["href"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "href": href,
//   };
// }

class States {
  dynamic code;
  String? name;

  States({
    this.code,
    this.name,
  });

  factory States.fromJson(Map<String, dynamic> json) => States(
    code: json["code"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "name": name,
  };
}
