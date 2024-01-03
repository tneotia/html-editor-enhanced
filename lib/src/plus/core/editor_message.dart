import 'dart:convert';

import 'package:html_editor_enhanced/src/plus/core/editor_event.dart';

/// A DTO representing a message transferred between dart and javascript.
class EditorMessage {
  /// The id of the HtmlElementView.
  final String key;

  /// The type of the message.
  ///
  /// If the message is sent from javascript, the type is `toDart`.
  /// If the message is sent from dart, the type is `toIframe`.
  final String type;

  /// The method used for the message.
  ///
  /// When the message is sent by the iframe, it should contain the callback.
  /// Example: `onChange`, `onImageLinkInsert`, etc.
  ///
  /// WHen the message is sent by dart, it should contain the summernote method to be called.
  /// Example: `fullscreen.toggle`, `reset`, etc.
  final String method;

  /// The payload of the message.
  ///
  /// This contains the data which should be passed through functions.
  /// If a value is a [Map] than use [jsonDecode] to decode it.
  final String? payload;

  @override
  int get hashCode => key.hashCode ^ type.hashCode ^ method.hashCode ^ payload.hashCode;

  /// Build a message.
  const EditorMessage({
    required this.key,
    this.type = "toDart",
    required this.method,
    this.payload,
  });

  factory EditorMessage.fromEvent({
    required String key,
    required EditorEvent event,
    String type = "toSummernote",
  }) =>
      EditorMessage(
        key: key,
        method: event.method,
        payload: event.payload,
        type: type,
      );

  factory EditorMessage.fromJson(Map<String, dynamic> map) {
    return EditorMessage(
      key: map["key"] as String,
      type: map["type"] as String,
      method: map["method"] as String,
      payload: map["payload"] != null ? map["payload"] as String : null,
    );
  }

  EditorMessage copyWith({
    String? key,
    String? type,
    String? method,
    String? payload,
  }) {
    return EditorMessage(
      key: key ?? this.key,
      type: type ?? this.type,
      method: method ?? this.method,
      payload: payload ?? this.payload,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        "key": key,
        "type": type,
        "method": method.toString(),
        if (payload != null) "payload": payload,
      };

  @override
  String toString() => "EditorMessage(key: $key, type: $type, event: $method, payload: $payload)";

  @override
  bool operator ==(covariant EditorMessage other) {
    if (identical(this, other)) return true;

    return other.key == key &&
        other.type == type &&
        other.method == method &&
        other.payload == payload;
  }
}
