import 'dart:convert';

RandomeQuots randomeQuotsFromJson(String str) =>
    RandomeQuots.fromJson(json.decode(str));

String randomeQuotsToJson(RandomeQuots data) => json.encode(data.toJson());

class RandomeQuots {
  String id;
  String content;
  String author;
  List<String> tags;
  String authorSlug;
  int length;
  DateTime dateAdded;
  DateTime dateModified;

  RandomeQuots({
    required this.id,
    required this.content,
    required this.author,
    required this.tags,
    required this.authorSlug,
    required this.length,
    required this.dateAdded,
    required this.dateModified,
  });

  factory RandomeQuots.fromJson(Map<String, dynamic> json) => RandomeQuots(
        id: json["_id"],
        content: json["content"],
        author: json["author"],
        tags: List<String>.from(json["tags"].map((x) => x)),
        authorSlug: json["authorSlug"],
        length: json["length"],
        dateAdded: DateTime.parse(json["dateAdded"]),
        dateModified: DateTime.parse(json["dateModified"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "content": content,
        "author": author,
        "tags": List<dynamic>.from(tags.map((x) => x)),
        "authorSlug": authorSlug,
        "length": length,
        "dateAdded":
            "${dateAdded.year.toString().padLeft(4, '0')}-${dateAdded.month.toString().padLeft(2, '0')}-${dateAdded.day.toString().padLeft(2, '0')}",
        "dateModified":
            "${dateModified.year.toString().padLeft(4, '0')}-${dateModified.month.toString().padLeft(2, '0')}-${dateModified.day.toString().padLeft(2, '0')}",
      };
}
