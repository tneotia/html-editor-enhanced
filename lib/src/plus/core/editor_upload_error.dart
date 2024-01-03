import 'dart:convert';

import 'package:html_editor_plus/src/plus/core/enums.dart';

import 'editor_file.dart';

/// Represents an error which occurred during the upload of a file.
class HtmlEditorUploadError {
  /// The error message.
  final UploadError error;

  /// The file which was uploaded.
  final HtmlEditorFile file;

  HtmlEditorUploadError({
    required this.error,
    required this.file,
  });

  factory HtmlEditorUploadError.fromJson(String source) => HtmlEditorUploadError.fromMap(
        json.decode(source) as Map<String, dynamic>,
      );

  factory HtmlEditorUploadError.fromMap(Map<String, dynamic> map) => HtmlEditorUploadError(
        error: _uploadErrorFromString(map['error'] as String),
        file: HtmlEditorFile.fromJson(map['file'] as String),
      );

  static UploadError _uploadErrorFromString(String error) => error.contains('base64')
      ? UploadError.jsException
      : (error.contains('unsupported') ? UploadError.unsupportedFile : UploadError.exceededMaxSize);

  @override
  String toString() => """HtmlEditorUploadError(
  error: $error, 
  file: $file,
)""";

  @override
  bool operator ==(covariant HtmlEditorUploadError other) {
    if (identical(this, other)) return true;

    return other.error == error && other.file == file;
  }

  @override
  int get hashCode => error.hashCode ^ file.hashCode;
}
