import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:html_editor_enhanced/src/plus/core/editor_event.dart';
import 'package:meta/meta.dart';

import 'core/editor_value.dart';

/// The controller for the HTML editor.
///
/// It's usage is similar to that of other controllers in Flutter.
/// Don't foget to call `dispose()` when you're done with it to avoid memory leaks.
///
/// [initialHtml] is the initial value provided to the editor.
class HtmlEditorController extends ValueNotifier<HtmlEditorValue> {
  StreamController<EditorEvent>? __eventsController;

  StreamController<EditorEvent> get _eventsController =>
      __eventsController ??= StreamController<EditorEvent>.broadcast();

  /// Determines whether text processing should happen on input HTML,
  /// e.g. whether a new line should be converted to a <br>.
  ///
  /// The default value is `true`.
  final bool processInputHtml;

  /// Determines whether newlines (\n) should be written as <br>. This is not
  /// recommended for HTML documents.
  ///
  /// The default value is `false`.
  final bool processNewLineAsBr;

  /// Determines whether text processing should happen on output HTML, e.g.
  /// whether <p><br></p> is returned as "".
  ///
  ///
  /// For reference, Summernote uses that HTML as the default HTML (when no text is in the editor).
  ///
  /// The default value is `true`.
  final bool processOutputHtml;

  /// The HTML value of the editor.
  ///
  /// When the value is changed, listeners will be notified.
  String get html => value.html;

  /// Get the processed html value of the editor.
  String get processedHtml =>
      (html.isEmpty || html == '<p></p>' || html == '<p><br></p>' || html == '<p><br/></p>')
          ? ""
          : html;

  /// Change the current html value of the editor.
  ///
  /// Listeners will be notified of the change.
  set html(String html) {
    value = value.copyWith(html: _processHtml(html: html));
  }

  /// Stream used to send events to the editor.
  @internal
  Stream<EditorEvent> get events => _eventsController.stream;

  /// Clone the current value to another instance.
  HtmlEditorValue get clonedValue => HtmlEditorValue.clone(value);

  HtmlEditorController({
    this.processInputHtml = true,
    this.processNewLineAsBr = false,
    this.processOutputHtml = true,
    String? initialHtml,
  }) : super(HtmlEditorValue.initial(html: initialHtml));

  /// Toggle between the code view and the rich text view.
  void toggleCodeView() => __eventsController?.add(const EditorToggleView());

  /// Clears the editor of any text.
  void clear() => __eventsController?.add(const EditorReset());

  /// Reloads the editor.
  void reload() => __eventsController?.add(const EditorReload());

  /// Undo the last action.
  void undo() => __eventsController?.add(const EditorUndo());

  /// Redo the last action.
  void redo() => __eventsController?.add(const EditorRedo());

  /// Enable the editor field.
  void enable() => __eventsController?.add(const EditorEnable());

  /// Disable the editor field.
  void disable() => __eventsController?.add(const EditorDisable());

  /// Request focus for the editor field.
  void requestFocus() => __eventsController?.add(const EditorRequestFocus());

  /// Clear the focus from the editor field.
  void clearFocus() => __eventsController?.add(const EditorClearFocus());

  /// Helper function to process input html
  String _processHtml({required html}) {
    if (processInputHtml) {
      html = kIsWeb
          ? html.replaceAll('\r', '').replaceAll('\r\n', '')
          : html
              .replaceAll("'", r"\'")
              .replaceAll('"', r'\"')
              .replaceAll('\r', '')
              .replaceAll('\r\n', '');
    }
    if (processNewLineAsBr) {
      html = html.replaceAll('\n', '<br/>').replaceAll('\n\n', '<br/>');
    } else {
      html = html.replaceAll('\n', '').replaceAll('\n\n', '');
    }
    return html;
  }

  @override
  void dispose() {
    __eventsController?.close();
    super.dispose();
  }
}
