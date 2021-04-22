import 'dart:convert';

/// Function that creates an instance of [FileUpload] from a JSON string
FileUpload fileUploadFromJson(String str) =>
    FileUpload.fromJson(json.decode(str));

/// The [FileUpload] class stores any known data about a file. This class is used
/// as an argument in some callbacks relating to image and file insertion.
///
/// The class holds last modified information, name, size, type, and the base64
/// of the file.
///
/// Note that all parameters are nullable to prevent any null-exception when
/// getting file data from JavaScript.
class FileUpload {
  FileUpload({
    this.base64,
    this.lastModified,
    this.lastModifiedDate,
    this.name,
    this.size,
    this.type,
  });

  /// The base64 string of the file.
  ///
  /// Note: This includes identifying data (e.g. data:image/jpeg;base64,) at the
  /// beginning. To strip this out, use FileUpload().base64.split(",")[1].
  String? base64;

  /// Last modified information in *milliseconds since epoch* format
  DateTime? lastModified;

  /// Last modified information in *regular date* format
  DateTime? lastModifiedDate;

  /// The filename
  String? name;

  /// The file size in bytes
  int? size;

  /// The content-type (eg. image/jpeg) of the file
  String? type;

  /// Creates an instance of [FileUpload] from a JSON string
  factory FileUpload.fromJson(Map<String, dynamic> json) => FileUpload(
        base64: json['base64'],
        lastModified: json['lastModified'] == null
            ? null
            : DateTime.fromMillisecondsSinceEpoch(json['lastModified']),
        lastModifiedDate: json['lastModifiedDate'] == null
            ? null
            : DateTime.tryParse(json['lastModifiedDate']),
        name: json['name'],
        size: json['size'],
        type: json['type'],
      );
}
