import 'editor_message.dart';

/// The list of callbacks which can be used in the editor.
enum EditorCallbacks implements Comparable<EditorCallbacks> {
  onInit(callback: "onInit"),
  onChange(callback: "onChange"),
  onChangeCodeview(callback: "onChangeCodeview"),
  onFocus(callback: "onFocus"),
  onBlur(callback: "onBlur"),
  onImageUpload(callback: "onImageUpload"),
  onImageUploadError(callback: "onImageUploadError");

  /// The name of the event.
  final String callback;

  const EditorCallbacks({required this.callback});

  static EditorCallbacks? fromMessage(EditorMessage message) => find(message.method);

  static EditorCallbacks? find(String name) {
    for (final event in EditorCallbacks.values) {
      if (event.callback == name) return event;
    }
    return null;
  }

  /// Override the compareTo method.
  @override
  int compareTo(EditorCallbacks other) => callback.compareTo(other.callback);

  @override
  String toString() => callback;
}
