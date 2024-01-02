import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:html_editor_enhanced/core.dart';
import 'package:html_editor_enhanced/editor_field.dart';

import '../editor_controller.dart';

/// {@macro HtmlEditorField}
///
/// This is used for mobile platforms.
class HtmlEditor extends StatefulWidget {
  /// {@macro ResizeMode}
  final ResizeMode resizeMode;

  /// {@macro HtmlEditorField.intialMobileOptions}
  final InAppWebViewGroupOptions? intialMobileOptions;

  /// {@macro HtmlEditorField.controller}
  final HtmlEditorController? controller;

  /// {@macro HtmlEditorField.themeData}
  final ThemeData? themeData;

  /// {@macro HtmlEditorField.onInit}
  final VoidCallback? onInit;

  /// {@macro HtmlEditorField.onFocus}
  final VoidCallback? onFocus;

  /// {@macro HtmlEditorField.onBlur}
  final VoidCallback? onBlur;

  /// {@macro HtmlEditorField.onImageLinkInsert}
  final ValueChanged<String>? onImageLinkInsert;

  const HtmlEditor({
    super.key,
    this.resizeMode = ResizeMode.resizeToParent,
    this.intialMobileOptions,
    this.controller,
    this.themeData,
    this.onInit,
    this.onFocus,
    this.onBlur,
    this.onImageLinkInsert,
  });

  @override
  State<HtmlEditor> createState() => _HtmlEditorState();
}

class _HtmlEditorState extends State<HtmlEditor> {
  late final HtmlEditorController _controller;
  ThemeData? _themeData;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? HtmlEditorController();
    _themeData = widget.themeData;
  }

  @override
  void didChangeDependencies() {
    if (widget.themeData == null) _themeData = Theme.of(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    if (widget.controller == null) _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => HtmlEditorField(
        key: widget.key,
        controller: _controller,
        resizeMode: widget.resizeMode,
        themeData: _themeData,
        intialMobileOptions: widget.intialMobileOptions,
        onInit: widget.onInit,
        onFocus: widget.onFocus,
        onBlur: widget.onBlur,
        onImageLinkInsert: widget.onImageLinkInsert,
      );
}
