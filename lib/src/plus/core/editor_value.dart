import 'package:flutter/foundation.dart';

@immutable
class HtmlEditorValue {
  final String html;

  /// Check if the [html] string is not empty.
  ///
  /// It trims the string and checks if it's not empty.
  bool get hasValue => html.trim().isNotEmpty;

  const HtmlEditorValue({this.html = ""});

  const HtmlEditorValue.initial({String? html}) : html = html ?? "";

  /// Make a new instance from another [HtmlEditorValue].
  factory HtmlEditorValue.clone(HtmlEditorValue other) => HtmlEditorValue(
        html: other.html,
      );

  HtmlEditorValue copyWith({
    String? html,
  }) {
    return HtmlEditorValue(
      html: html ?? this.html,
    );
  }

  @override
  bool operator ==(covariant HtmlEditorValue other) {
    if (identical(this, other)) return true;

    return other.html == html;
  }

  @override
  int get hashCode => html.hashCode;
}
