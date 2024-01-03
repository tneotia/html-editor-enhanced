import 'dart:convert';
import 'dart:typed_data';

/// Represents a file which was uploaded in the editor.
class HtmlEditorFile {
  /// The name of the file.
  final String name;

  /// The size of the file in bytes.
  final int? size;

  /// The MIME type of the file.
  final String? mimeType;

  /// The base64 representation of the file.
  final String? base64;

  /// The last modified date of the file as unix timestamp.
  final int? lastModified;

  /// The last modified date of the file as [DateTime].
  final DateTime? lastModifiedDate;

  /// Decodes the base64 string and retrieve it as a [Uint8List].
  Uint8List? get readAsBytes => (base64?.isNotEmpty ?? false) ? base64Decode(base64!) : null;

  const HtmlEditorFile({
    required this.name,
    this.size,
    this.mimeType,
    this.base64,
    this.lastModified,
    this.lastModifiedDate,
  });

  factory HtmlEditorFile.fromMap(Map<String, dynamic> map) => HtmlEditorFile(
        name: map['name'] as String,
        size: map['size'] != null ? map['size'] as int : null,
        mimeType: map['mimeType'] != null ? map['mimeType'] as String : null,
        base64: map['base64'] as String,
        lastModified: map['lastModified'] != null ? map['lastModified'] as int : null,
        lastModifiedDate: map['lastModifiedDate'] != null
            ? DateTime.tryParse(map['lastModifiedDate'] as String)
            : null,
      );

  factory HtmlEditorFile.fromJson(String source) => HtmlEditorFile.fromMap(
        json.decode(source) as Map<String, dynamic>,
      );

  HtmlEditorFile copyWith({
    String? name,
    int? size,
    String? mimeType,
    String? base64,
    int? lastModified,
    DateTime? lastModifiedDate,
  }) {
    return HtmlEditorFile(
      name: name ?? this.name,
      size: size ?? this.size,
      mimeType: mimeType ?? this.mimeType,
      base64: base64 ?? this.base64,
      lastModified: lastModified ?? this.lastModified,
      lastModifiedDate: lastModifiedDate ?? this.lastModifiedDate,
    );
  }

  Map<String, dynamic> toMap() => {
        'name': name,
        'size': size,
        'mimeType': mimeType,
        'base64': base64,
        'lastModified': lastModified,
        'lastModifiedDate': lastModifiedDate?.millisecondsSinceEpoch,
      };

  String toJson() => json.encode(toMap());

  @override
  String toString() => """HtmlEditorFile(
  name: $name, 
  size: $size, 
  mimeType: $mimeType, 
  hasBase64Content: ${base64?.trim().isNotEmpty}, 
  lastModified: $lastModified, 
  lastModifiedDate: $lastModifiedDate,
)""";

  @override
  bool operator ==(covariant HtmlEditorFile other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.size == size &&
        other.mimeType == mimeType &&
        other.base64 == base64 &&
        other.lastModified == lastModified &&
        other.lastModifiedDate == lastModifiedDate;
  }

  @override
  int get hashCode =>
      name.hashCode ^
      size.hashCode ^
      mimeType.hashCode ^
      base64.hashCode ^
      lastModified.hashCode ^
      lastModifiedDate.hashCode;
}
