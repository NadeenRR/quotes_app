import 'dart:convert';

RandomeImage randomeImageFromJson(String str) =>
    RandomeImage.fromJson(json.decode(str));

String randomeImageToJson(RandomeImage data) => json.encode(data.toJson());

class RandomeImage {
  String provider;
  String license;
  String terms;
  String url;
  Size size;

  RandomeImage({
    required this.provider,
    required this.license,
    required this.terms,
    required this.url,
    required this.size,
  });

  factory RandomeImage.fromJson(Map<String, dynamic> json) => RandomeImage(
        provider: json["provider"],
        license: json["license"],
        terms: json["terms"],
        url: json["url"],
        size: Size.fromJson(json["size"]),
      );

  Map<String, dynamic> toJson() => {
        "provider": provider,
        "license": license,
        "terms": terms,
        "url": url,
        "size": size.toJson(),
      };
}

class Size {
  int height;
  int width;

  Size({
    required this.height,
    required this.width,
  });

  factory Size.fromJson(Map<String, dynamic> json) => Size(
        height: json["height"],
        width: json["width"],
      );

  Map<String, dynamic> toJson() => {
        "height": height,
        "width": width,
      };
}
