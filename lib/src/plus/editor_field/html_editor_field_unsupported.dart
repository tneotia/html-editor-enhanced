import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../editor_controller.dart';
import '../core/enums.dart';

/// {@template HtmlEditorField}
/// The widget representing the editor's text field where the user can insert the text.
/// {@endtemplate}
///
/// This is used for unsupported platforms.
class HtmlEditorField extends StatelessWidget {
  /// {@macro ResizeMode}
  final ResizeMode resizeMode;

  /// {@template HtmlEditorField.controller}
  /// The controller for the HTML editor.
  ///
  /// Provide a controller if you want to control the HTML editor programmatically.
  ///
  /// If you are using [HtmlEditorField] directly, you are `required` to provide a controller.
  /// {@endtemplate}
  final HtmlEditorController controller;

  /// {@template HtmlEditorField.themeData}
  /// Theme data used by the editor.
  ///
  /// It's used to set the colors for background/foreground elements of the editor.
  /// It uses [Colorscheme.surface] to set the background color of the editor.
  /// It uses [Colorscheme.onSurface] to set the foreground color of the editor.
  /// It uses [Colorscheme.surfaceVariant] to set the background color for other elements,
  /// such as buttons/toolbar/etc.
  ///
  /// More in-depth customization will be available in the future.
  /// {@endtemplate}
  final ThemeData? themeData;

  /// {@template HtmlEditorField.intialMobileOptions}
  /// The initial options for the [InAppWebViewGroupOptions] used only on mobile platforms.
  ///
  /// If not specified, these default options are used:
  /// ```dart
  /// InAppWebViewGroupOptions(
  ///   crossPlatform: InAppWebViewOptions(
  ///     javaScriptEnabled: true,
  ///     transparentBackground: true,
  ///     useShouldOverrideUrlLoading: true,
  ///   ),
  ///   android: AndroidInAppWebViewOptions(
  ///     useHybridComposition: true,
  ///     loadWithOverviewMode: true,
  ///   ),
  /// );
  /// ```
  /// {@endtemplate}
  final InAppWebViewGroupOptions? intialMobileOptions;

  /// {@template HtmlEditorField.onInit}
  /// Callback to be called when the editor is initialized.
  /// {@endtemplate}
  final VoidCallback? onInit;

  /// {@template HtmlEditorField.onFocus}
  /// Callback to be called when the editor gains focus.
  /// {@endtemplate}
  final VoidCallback? onFocus;

  /// {@template HtmlEditorField.onBlur}
  /// Callback to be called when the editor loses focus.
  /// {@endtemplate}
  final VoidCallback? onBlur;

  const HtmlEditorField({
    super.key,
    required this.controller,
    this.resizeMode = ResizeMode.resizeToParent,
    this.themeData,
    this.intialMobileOptions,
    this.onInit,
    this.onFocus,
    this.onBlur,
  });

  @override
  Widget build(BuildContext context) => const Center(
        child: Text("Unsupported in this environment"),
      );
}
