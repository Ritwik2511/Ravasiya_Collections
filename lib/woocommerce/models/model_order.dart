import 'dart:convert';

List<ModelOrderNote?>? modelOrderNoteFromJson(String str) =>
    json.decode(str) == null
        ? []
        : List<ModelOrderNote?>.from(
            json.decode(str)!.map((x) => ModelOrderNote.fromJson(x)));

String modelOrderNoteToJson(List<ModelOrderNote?>? data) => json.encode(
    data == null ? [] : List<dynamic>.from(data.map((x) => x!.toJson())));

class ModelOrderNote {
  ModelOrderNote({
    required this.id,
    required this.author,
    required this.dateCreated,
    required this.dateCreatedGmt,
    required this.note,
    required this.customerNote,
  });

  final int? id;
  final String? author;
  final DateTime? dateCreated;
  final DateTime? dateCreatedGmt;
  final String? note;
  final bool? customerNote;

  factory ModelOrderNote.fromJson(Map<String, dynamic> json) => ModelOrderNote(
        id: json["id"],
        author: json["author"],
        dateCreated: DateTime.parse(json["date_created"]),
        dateCreatedGmt: DateTime.parse(json["date_created_gmt"]),
        note: json["note"],
        customerNote: json["customer_note"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "author": author,
        "date_created": dateCreated?.toIso8601String(),
        "date_created_gmt": dateCreatedGmt?.toIso8601String(),
        "note": note,
        "customer_note": customerNote,
      };
}
//
// class Links {
//   Links({
//     required this.self,
//     required this.collection,
//     required this.up,
//   });
//
//   final List<Collection?>? self;
//   final List<Collection?>? collection;
//   final List<Collection?>? up;
//
//   factory Links.fromJson(Map<String, dynamic> json) => Links(
//     self: json["self"] == null ? [] : List<Collection?>.from(json["self"]!.map((x) => Collection.fromJson(x))),
//     collection: json["collection"] == null ? [] : List<Collection?>.from(json["collection"]!.map((x) => Collection.fromJson(x))),
//     up: json["up"] == null ? [] : List<Collection?>.from(json["up"]!.map((x) => Collection.fromJson(x))),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "self": self == null ? [] : List<dynamic>.from(self!.map((x) => x!.toJson())),
//     "collection": collection == null ? [] : List<dynamic>.from(collection!.map((x) => x!.toJson())),
//     "up": up == null ? [] : List<dynamic>.from(up!.map((x) => x!.toJson())),
//   };
// }
//
// class Collection {
//   Collection({
//     required this.href,
//   });
//
//   final String? href;
//
//   factory Collection.fromJson(Map<String, dynamic> json) => Collection(
//     href: json["href"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "href": href,
//   };
// }
