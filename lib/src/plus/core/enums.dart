/// {@template ResizeMode}
/// Defines the resize mode of the editor.
///
/// [resizeToContent] will resize the editor to the content of the summernote editor.
/// [resizeToParent] will resize the editor to the parent widget. When this mode is enabled,
/// the editor will size itself to the maximum allowed by the parent.
/// {@endtemplate}
enum ResizeMode {
  resizeToContent,
  resizeToParent,
}

/// Defines the 3 different cases for file insertion failing
enum UploadError {
  unsupportedFile,
  exceededMaxSize,
  jsException,
}
