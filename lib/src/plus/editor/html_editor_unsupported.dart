import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../core/editor_file.dart';
import '../core/editor_upload_error.dart';
import '../core/enums.dart';
import '../editor_controller.dart';

/// {@template HtmlEditor}
/// The full HTML editor widget.
///
/// It contains the editor's text field where the user can insert the text, aswell as the toolbar.
/// {@endtemplate}
///
/// This is used for unsupported platforms.
class HtmlEditor extends StatelessWidget {
  /// {@macro ResizeMode}
  final ResizeMode resizeMode;

  /// {@macro HtmlEditorField.controller}
  final HtmlEditorController? controller;

  /// {@macro HtmlEditorField.themeData}
  ///
  /// If not specified, the default theme data is used, provided from Theme.of(context).
  final ThemeData? themeData;

  /// {@macro HtmlEditorField.intialMobileOptions}
  final InAppWebViewGroupOptions? intialMobileOptions;

  /// {@macro HtmlEditorField.onInit}
  final VoidCallback? onInit;

  /// {@macro HtmlEditorField.onFocus}
  final VoidCallback? onFocus;

  /// {@macro HtmlEditorField.onBlur}
  final VoidCallback? onBlur;

  /// {@macro HtmlEditorField.onImageUpload}
  final ValueChanged<HtmlEditorFile>? onImageUpload;

  /// {@macro HtmlEditorField.onImageUploadError}
  final ValueChanged<HtmlEditorUploadError>? onImageUploadError;

  const HtmlEditor({
    super.key,
    this.resizeMode = ResizeMode.resizeToParent,
    this.intialMobileOptions,
    this.controller,
    this.themeData,
    this.onInit,
    this.onFocus,
    this.onBlur,
    this.onImageUpload,
    this.onImageUploadError,
  });

  @override
  Widget build(BuildContext context) => const Center(
        child: Text("Unsupported in this environment"),
      );
}
