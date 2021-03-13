import 'dart:convert';

FileUpload fileUploadFromJson(String str) => FileUpload.fromJson(json.decode(str));

class FileUpload {
  FileUpload({
    this.lastModified,
    this.lastModifiedDate,
    this.name,
    this.size,
    this.type,
  });

  DateTime? lastModified;
  DateTime? lastModifiedDate;
  String? name;
  int? size;
  String? type;

  factory FileUpload.fromJson(Map<String, dynamic> json) => FileUpload(
    lastModified: json["lastModified"] == null ? null : DateTime.fromMillisecondsSinceEpoch(json["lastModified"]),
    lastModifiedDate: json["lastModifiedDate"] == null ? null : DateTime.tryParse(json["lastModifiedDate"]),
    name: json["name"] == null ? null : json["name"],
    size: json["size"] == null ? null : json["size"],
    type: json["type"] == null ? null : json["type"],
  );
}