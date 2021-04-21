import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

/// Toolbar widget class
class ToolbarWidget extends StatefulWidget {
  /// The [HtmlEditorController] is mainly used to call the [execCommand] method
  final HtmlEditorController controller;
  final HtmlToolbarOptions options;

  const ToolbarWidget({
    Key? key,
    required this.controller,
    required this.options,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ToolbarWidgetState();
  }
}

/// Toolbar widget state
class ToolbarWidgetState extends State<ToolbarWidget> {
  /// List that controls which [ToggleButtons] are selected for
  /// bold/italic/underline/clear styles
  List<bool> _fontSelected = List<bool>.filled(4, false);

  /// List that controls which [ToggleButtons] are selected for
  /// strikthrough/superscript/subscript
  List<bool> _miscFontSelected = List<bool>.filled(3, false);

  /// List that controls which [ToggleButtons] are selected for
  /// forecolor/backcolor
  List<bool> _colorSelected = List<bool>.filled(2, false);

  /// List that controls which [ToggleButtons] are selected for
  /// ordered/unordered list
  List<bool> _listSelected = List<bool>.filled(2, false);

  /// List that controls which [ToggleButtons] are selected for
  /// fullscreen, codeview, undo, redo, and help. Fullscreen and codeview
  /// are the only buttons that will ever be selected.
  List<bool> _miscSelected = List<bool>.filled(5, false);

  /// List that controls which [ToggleButtons] are selected for
  /// justify left/right/center/full.
  List<bool> _alignSelected = List<bool>.filled(4, false);

  List<bool> _textDirectionSelected = List<bool>.filled(2, false);

  /// Sets the selected item for the font style dropdown
  String _fontSelectedItem = "p";

  String _fontNameSelectedItem = "sans-serif";
  /// Sets the selected item for the font size dropdown
  double _fontSizeSelectedItem = 3;

  /// Keeps track of the current font size in px
  double _actualFontSizeSelectedItem = 16;

  /// Sets the selected item for the font units dropdown
  String _fontSizeUnitSelectedItem = "pt";

  /// Sets the selected item for the foreground color dialog
  Color _foreColorSelected = Colors.black;

  /// Sets the selected item for the background color dialog
  Color _backColorSelected = Colors.yellow;

  /// Sets the selected item for the list style dropdown
  String? _listStyleSelectedItem;

  /// Sets the selected item for the line height dropdown
  double _lineHeightSelectedItem = 1;

  /// Masks the toolbar with a grey color if false
  bool _enabled = true;

  @override
  void initState() {
    widget.controller.toolbar = this;
    for (Toolbar t in widget.options.defaultToolbarButtons) {
      if (t is FontButtons) {
        _fontSelected = List<bool>.filled(t.getIcons1().length, false);
        _miscFontSelected = List<bool>.filled(t.getIcons2().length, false);
      }
      if (t is ColorButtons) {
        _colorSelected = List<bool>.filled(t.getIcons().length, false);
      }
      if (t is ListButtons) {
        _listSelected = List<bool>.filled(t.getIcons().length, false);
      }
      if (t is OtherButtons) {
        _miscSelected = List<bool>.filled(t.getIcons1().length, false);
      }
      if (t is ParagraphButtons) {
        _alignSelected = List<bool>.filled(t.getIcons1().length, false);
      }
    }
    super.initState();
  }

  void disable() {
    setState(() {
      _enabled = false;
    });
  }

  void enable() {
    setState(() {
      _enabled = true;
    });
  }

  /// Updates the toolbar from the JS handler on mobile and the onMessage
  /// listener on web
  void updateToolbar(Map<String, dynamic> json) {
    print(json);
    //get parent element
    String parentElem = json['style'] ?? "";
    //get font name
    String fontName = (json['fontName'] ?? "").toString().replaceAll('"', "");
    //get font size
    double fontSize = double.tryParse(json['fontSize']) ?? 3;
    //get bold/underline/italic status
    List<bool?> fontList = (json['font'] as List<dynamic>).cast<bool?>();
    //get superscript/subscript/strikethrough status
    List<bool?> miscFontList = (json['miscFont'] as List<dynamic>).cast<bool?>();
    //get forecolor/backcolor
    List<String?> colorList = (json['color'] as List<dynamic>).cast<String?>();
    //get ordered/unordered list status
    List<bool?> paragraphList = (json['paragraph'] as List<dynamic>).cast<bool?>();
    //get justify status
    List<bool?> alignList = (json['align'] as List<dynamic>).cast<bool?>();
    //get line height
    String lineHeight = json['lineHeight'] ?? "";
    //get list icon type
    String listType = json['listStyle'] ?? "";
    //get text direction
    String textDir = json['direction'] ?? "ltr";
    //check the parent element if it matches one of the predetermined styles and update the toolbar
    if (['pre', 'blockquote', 'h1', 'h2', 'h3', 'h4', 'h5', 'h6'].contains(parentElem)) {
      setState(() {
        _fontSelectedItem = parentElem;
      });
    } else {
      setState(() {
        _fontSelectedItem = "p";
      });
    }
    //check the font name if it matches one of the predetermined fonts and update the toolbar
    if (['Courier New', 'sans-serif', 'Times New Roman'].contains(fontName)) {
      print("fired");
      setState(() {
        _fontNameSelectedItem = fontName;
      });
    } else {
      setState(() {
        _fontNameSelectedItem = "sans-serif";
      });
    }
    //update the fore/back selected color if necessary
    if (colorList[0] != null && colorList[0]!.isNotEmpty) {
      setState(() {
        String rgb = colorList[0]!.replaceAll("rgb(", "").replaceAll(")", "");
        List<String> rgbList = rgb.split(", ");
        _foreColorSelected = Color.fromRGBO(int.parse(rgbList[0]), int.parse(rgbList[1]), int.parse(rgbList[2]), 1);
      });
    } else {
      setState(() {
        _foreColorSelected = Colors.black;
      });
    }
    if (colorList[1] != null && colorList[1]!.isNotEmpty) {
      setState(() {
        _backColorSelected = Color(int.parse(colorList[1]!, radix: 16) + 0xFF000000);
      });
    } else {
      setState(() {
        _backColorSelected = Colors.yellow;
      });
    }
    //check the list style if it matches one of the predetermined styles and update the toolbar
    if (['decimal', 'lower-alpha', 'upper-alpha', 'lower-roman', 'upper-roman', 'disc', 'circle', 'square'].contains(listType)) {
      setState(() {
        _listStyleSelectedItem = listType;
      });
    } else {
      _listStyleSelectedItem = null;
    }
    //update the lineheight selected item if necessary
    if (lineHeight.isNotEmpty && lineHeight.endsWith("px")) {
      double lineHeightDouble = double.tryParse(lineHeight.replaceAll("px", "")) ?? 16;
      List<double> lineHeights = [1, 1.2, 1.4, 1.5, 1.6, 1.8, 2, 3];
      lineHeights = lineHeights.map((e) => e * _actualFontSizeSelectedItem).toList();
      if (lineHeights.contains(lineHeightDouble)) {
        setState(() {
          _lineHeightSelectedItem = lineHeightDouble / _actualFontSizeSelectedItem;
        });
      }
    } else if (lineHeight == "normal") {
      setState(() {
        _lineHeightSelectedItem = 1.0;
      });
    }
    //check if the font size matches one of the predetermined sizes and update the toolbar
    if ([1, 2, 3, 4, 5, 6, 7].contains(fontSize)) {
      setState(() {
        _fontSizeSelectedItem = fontSize;
      });
    }
    if (textDir == "ltr") {
      setState(() {
        _textDirectionSelected = [true, false];
      });
    } else if (textDir == "rtl") {
      setState(() {
        _textDirectionSelected = [false, true];
      });
    }
    //use the remaining bool lists to update the selected items accordingly
    setState(() {
      for (Toolbar t in widget.options.defaultToolbarButtons) {
        if (t is FontButtons) {
          for (int i = 0; i < _fontSelected.length; i++) {
            if (t.getIcons1()[i].icon == Icons.format_bold) {
              _fontSelected[i] = fontList[0] ?? false;
            }
            if (t.getIcons1()[i].icon == Icons.format_italic) {
              _fontSelected[i] = fontList[1] ?? false;
            }
            if (t.getIcons1()[i].icon == Icons.format_underline) {
              _fontSelected[i] = fontList[2] ?? false;
            }
          }
          for (int i = 0; i < _miscFontSelected.length; i++) {
            if (t.getIcons2()[i].icon == Icons.format_strikethrough) {
              _miscFontSelected[i] = miscFontList[0] ?? false;
            }
            if (t.getIcons2()[i].icon == Icons.superscript) {
              _miscFontSelected[i] = miscFontList[1] ?? false;
            }
            if (t.getIcons2()[i].icon == Icons.subscript) {
              _miscFontSelected[i] = miscFontList[2] ?? false;
            }
          }
        }
        if (t is ListButtons) {
          for (int i = 0; i < _listSelected.length; i++) {
            if (t.getIcons()[i].icon == Icons.format_list_bulleted) {
              _listSelected[i] = paragraphList[0] ?? false;
            }
            if (t.getIcons()[i].icon == Icons.format_list_numbered) {
              _listSelected[i] = paragraphList[1] ?? false;
            }
          }
        }
        if (t is ParagraphButtons) {
          for (int i = 0; i < _alignSelected.length; i++) {
            if (t.getIcons1()[i].icon == Icons.format_align_left) {
              _alignSelected[i] = alignList[0] ?? false;
            }
            if (t.getIcons1()[i].icon == Icons.format_align_center) {
              _alignSelected[i] = alignList[1] ?? false;
            }
            if (t.getIcons1()[i].icon == Icons.format_align_right) {
              _alignSelected[i] = alignList[2] ?? false;
            }
            if (t.getIcons1()[i].icon == Icons.format_align_justify) {
              _alignSelected[i] = alignList[3] ?? false;
            }
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.options.toolbarType == ToolbarType.nativeGrid) {
      return PointerInterceptor(
        child: AbsorbPointer(
          absorbing: !_enabled,
          child: Opacity(
            opacity: _enabled ? 1 : 0.5,
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Wrap(
                runSpacing: widget.options.gridViewVerticalSpacing,
                spacing: widget.options.gridViewHorizontalSpacing,
                children: _buildChildren(),
              ),
            ),
          ),
        ),
      );
    } else {
      return PointerInterceptor(
        child: AbsorbPointer(
          absorbing: !_enabled,
          child: Opacity(
            opacity: _enabled ? 1 : 0.5,
            child: Container(
              height: widget.options.toolbarItemHeight + 15,
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: CustomScrollView(
                  scrollDirection: Axis.horizontal,
                  slivers: [
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: _buildChildren(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }
  }

  List<Widget> _buildChildren() {
    List<Widget> toolbarChildren = [];
    for (Toolbar t in widget.options.defaultToolbarButtons) {
      if (t is StyleButtons) {
        toolbarChildren.add(Container(
          padding: const EdgeInsets.only(left: 8.0),
          height: widget.options.toolbarItemHeight,
          decoration: !widget.options.renderBorder ? null :
          widget.options.dropdownBoxDecoration ?? BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              border: Border.all(color: ToggleButtonsTheme.of(context).borderColor ?? Colors.grey[800]!)
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              elevation: widget.options.dropdownElevation,
              icon: widget.options.dropdownIcon,
              iconEnabledColor: widget.options.dropdownIconColor,
              iconSize: widget.options.dropdownIconSize,
              itemHeight: widget.options.dropdownItemHeight,
              focusColor: widget.options.dropdownFocusColor,
              dropdownColor: widget.options.dropdownBackgroundColor,
              menuMaxHeight: widget.options.dropdownMenuMaxHeight,
              style: widget.options.textStyle,
              items: [
                DropdownMenuItem(child: PointerInterceptor(child: Text("Normal")), value: "p"),
                DropdownMenuItem(
                    child: PointerInterceptor(
                      child: Container(
                          decoration: BoxDecoration(border: Border(left: BorderSide(color: Colors.grey, width: 3.0))),
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text("Quote", style: TextStyle(fontFamily: "times", color: Colors.grey))
                      ),
                    ),
                    value: "blockquote"
                ),
                DropdownMenuItem(
                    child: PointerInterceptor(
                      child: Container(
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: Colors.grey),
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text("Code", style: TextStyle(fontFamily: "courier", color: Colors.white))
                      ),
                    ),
                    value: "pre"
                ),
                DropdownMenuItem(child: PointerInterceptor(child: Text("Header 1", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32))), value: "h1"),
                DropdownMenuItem(child: PointerInterceptor(child: Text("Header 2", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24))), value: "h2"),
                DropdownMenuItem(child: PointerInterceptor(child: Text("Header 3", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))), value: "h3"),
                DropdownMenuItem(child: PointerInterceptor(child: Text("Header 4", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))), value: "h4"),
                DropdownMenuItem(child: PointerInterceptor(child: Text("Header 5", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13))), value: "h5"),
                DropdownMenuItem(child: PointerInterceptor(child: Text("Header 6", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11))), value: "h6"),
              ],
              value: _fontSelectedItem,
              onChanged: (String? changed) async {
                void updateSelectedItem(dynamic changed) {
                  if (changed is String) {
                    setState(() {
                      _fontSelectedItem = changed;
                    });
                  }
                }

                if (changed != null) {
                  bool proceed = await widget.options.onDropdownChanged?.call(DropdownType.style, changed, updateSelectedItem) ?? true;
                  if (proceed) {
                    widget.controller.execCommand('formatBlock', argument: changed);
                    updateSelectedItem(changed);
                  }
                }
              },
            ),
          ),
        ));
      }
      if (t is FontSettingButtons) {
        if (t.fontName) toolbarChildren.add(Container(
          padding: const EdgeInsets.only(left: 8.0),
          height: widget.options.toolbarItemHeight,
          decoration: !widget.options.renderBorder ? null :
          widget.options.dropdownBoxDecoration ?? BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              border: Border.all(color: ToggleButtonsTheme.of(context).borderColor ?? Colors.grey[800]!)
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              elevation: widget.options.dropdownElevation,
              icon: widget.options.dropdownIcon,
              iconEnabledColor: widget.options.dropdownIconColor,
              iconSize: widget.options.dropdownIconSize,
              itemHeight: widget.options.dropdownItemHeight,
              focusColor: widget.options.dropdownFocusColor,
              dropdownColor: widget.options.dropdownBackgroundColor,
              menuMaxHeight: widget.options.dropdownMenuMaxHeight,
              style: widget.options.textStyle,
              items: [
                DropdownMenuItem(child: PointerInterceptor(child: Text("Courier New", style: TextStyle(fontFamily: "Courier"))), value: "Courier New"),
                DropdownMenuItem(child: PointerInterceptor(child: Text("Sans Serif", style: TextStyle(fontFamily: "sans-serif"))), value: "sans-serif"),
                DropdownMenuItem(child: PointerInterceptor(child: Text("Times New Roman", style: TextStyle(fontFamily: "Times"))), value: "Times New Roman"),
              ],
              value: _fontNameSelectedItem,
              onChanged: (String? changed) async {
                void updateSelectedItem(dynamic changed) async {
                  if (changed is String) {
                    setState(() {
                      _fontNameSelectedItem = changed;
                    });
                  }
                }

                if (changed != null) {
                  bool proceed = await widget.options.onDropdownChanged?.call(DropdownType.fontName, changed, updateSelectedItem) ?? true;
                  if (proceed) {
                    widget.controller.execCommand("fontName", argument: changed);
                    updateSelectedItem(changed);
                  }
                }
              },
            ),
          ),
        ));
        if (t.fontSize) toolbarChildren.add(Container(
          padding: const EdgeInsets.only(left: 8.0),
          height: widget.options.toolbarItemHeight,
          decoration: !widget.options.renderBorder ? null :
          widget.options.dropdownBoxDecoration ?? BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              border: Border.all(color: ToggleButtonsTheme.of(context).borderColor ?? Colors.grey[800]!)
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<double>(
              elevation: widget.options.dropdownElevation,
              icon: widget.options.dropdownIcon,
              iconEnabledColor: widget.options.dropdownIconColor,
              iconSize: widget.options.dropdownIconSize,
              itemHeight: widget.options.dropdownItemHeight,
              focusColor: widget.options.dropdownFocusColor,
              dropdownColor: widget.options.dropdownBackgroundColor,
              menuMaxHeight: widget.options.dropdownMenuMaxHeight,
              style: widget.options.textStyle,
              items: [
                DropdownMenuItem(
                    child: PointerInterceptor(child: Text("${_fontSizeUnitSelectedItem == "px" ? "11" : "8"} $_fontSizeUnitSelectedItem")),
                    value: 1
                ),
                DropdownMenuItem(
                    child: PointerInterceptor(child: Text("${_fontSizeUnitSelectedItem == "px" ? "13" : "10"} $_fontSizeUnitSelectedItem")),
                    value: 2
                ),
                DropdownMenuItem(
                    child: PointerInterceptor(child: Text("${_fontSizeUnitSelectedItem == "px" ? "16" : "12"} $_fontSizeUnitSelectedItem")),
                    value: 3
                ),
                DropdownMenuItem(
                    child: PointerInterceptor(child: Text("${_fontSizeUnitSelectedItem == "px" ? "19" : "14"} $_fontSizeUnitSelectedItem")),
                    value: 4
                ),
                DropdownMenuItem(
                    child: PointerInterceptor(child: Text("${_fontSizeUnitSelectedItem == "px" ? "24" : "18"} $_fontSizeUnitSelectedItem")),
                    value: 5
                ),
                DropdownMenuItem(
                    child: PointerInterceptor(child: Text("${_fontSizeUnitSelectedItem == "px" ? "32" : "24"} $_fontSizeUnitSelectedItem")),
                    value: 6
                ),
                DropdownMenuItem(
                    child: PointerInterceptor(child: Text("${_fontSizeUnitSelectedItem == "px" ? "48" : "36"} $_fontSizeUnitSelectedItem")),
                    value: 7
                ),
              ],
              value: _fontSizeSelectedItem,
              onChanged: (double? changed) async {
                void updateSelectedItem(dynamic changed) {
                  if (changed is double) {
                    setState(() {
                      _fontSizeSelectedItem = changed;
                    });
                  }
                }

                if (changed != null) {
                  int intChanged = changed.toInt();
                  bool proceed = await widget.options.onDropdownChanged?.call(DropdownType.fontSize, changed, updateSelectedItem) ?? true;
                  if (proceed) {
                    switch (intChanged) {
                      case 1:
                        _actualFontSizeSelectedItem = 11;
                        break;
                      case 2:
                        _actualFontSizeSelectedItem = 13;
                        break;
                      case 3:
                        _actualFontSizeSelectedItem = 16;
                        break;
                      case 4:
                        _actualFontSizeSelectedItem = 19;
                        break;
                      case 5:
                        _actualFontSizeSelectedItem = 24;
                        break;
                      case 6:
                        _actualFontSizeSelectedItem = 32;
                        break;
                      case 7:
                        _actualFontSizeSelectedItem = 48;
                        break;
                    }
                    widget.controller.execCommand('fontSize', argument: changed.toString());
                    updateSelectedItem(changed);
                  }
                }
              },
            ),
          ),
        ));
        if (t.fontSizeUnit) toolbarChildren.add(Container(
          padding: const EdgeInsets.only(left: 8.0),
          height: widget.options.toolbarItemHeight,
          decoration: !widget.options.renderBorder ? null :
          widget.options.dropdownBoxDecoration ?? BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              border: Border.all(color: ToggleButtonsTheme.of(context).borderColor ?? Colors.grey[800]!)
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              elevation: widget.options.dropdownElevation,
              icon: widget.options.dropdownIcon,
              iconEnabledColor: widget.options.dropdownIconColor,
              iconSize: widget.options.dropdownIconSize,
              itemHeight: widget.options.dropdownItemHeight,
              focusColor: widget.options.dropdownFocusColor,
              dropdownColor: widget.options.dropdownBackgroundColor,
              menuMaxHeight: widget.options.dropdownMenuMaxHeight,
              style: widget.options.textStyle,
              items: [
                DropdownMenuItem(child: PointerInterceptor(child: Text("pt")), value: "pt"),
                DropdownMenuItem(child: PointerInterceptor(child: Text("px")), value: "px"),
              ],
              value: _fontSizeUnitSelectedItem,
              onChanged: (String? changed) async {
                void updateSelectedItem(dynamic changed) {
                  if (changed is String) {
                    setState(() {
                      _fontSizeUnitSelectedItem = changed;
                    });
                  }
                }

                if (changed != null) {
                  bool proceed = await widget.options.onDropdownChanged?.call(DropdownType.fontSizeUnit, changed, updateSelectedItem) ?? true;
                  if (proceed) {
                    updateSelectedItem(changed);
                  }
                }
              },
            ),
          ),
        ));
      }
      if (t is FontButtons) {
        if (t.bold || t.italic || t.underline || t.clearAll) {
          toolbarChildren.add(ToggleButtons(
            constraints: BoxConstraints.tightFor(
              width: widget.options.toolbarItemHeight - 2,
              height: widget.options.toolbarItemHeight - 2,
            ),
            color: widget.options.buttonColor,
            selectedColor: widget.options.buttonSelectedColor,
            fillColor: widget.options.buttonFillColor,
            focusColor: widget.options.buttonFocusColor,
            highlightColor: widget.options.buttonHighlightColor,
            hoverColor: widget.options.buttonHoverColor,
            splashColor: widget.options.buttonSplashColor,
            selectedBorderColor: widget.options.buttonSelectedBorderColor,
            borderColor: widget.options.buttonBorderColor,
            borderRadius: widget.options.buttonBorderRadius,
            borderWidth: widget.options.buttonBorderWidth,
            renderBorder: widget.options.renderBorder,
            textStyle: widget.options.textStyle,
            children: t.getIcons1(),
            onPressed: (int index) async {
              void updateStatus() {
                setState(() {
                  _fontSelected[index] = !_fontSelected[index];
                });
              }

              if (t.getIcons1()[index].icon == Icons.format_bold) {
                bool proceed = await widget.options.onButtonPressed?.call(ButtonType.bold, _fontSelected[index], updateStatus) ?? true;
                if (proceed) {
                  widget.controller.execCommand('bold');
                  updateStatus();
                }
              }
              if (t.getIcons1()[index].icon == Icons.format_italic) {
                bool proceed = await widget.options.onButtonPressed?.call(ButtonType.italic, _fontSelected[index], updateStatus) ?? true;
                if (proceed) {
                  widget.controller.execCommand('italic');
                  updateStatus();
                }
              }
              if (t.getIcons1()[index].icon == Icons.format_underline) {
                bool proceed = await widget.options.onButtonPressed?.call(ButtonType.underline, _fontSelected[index], updateStatus) ?? true;
                if (proceed) {
                  widget.controller.execCommand('underline');
                  updateStatus();
                }
              }
              if (t.getIcons1()[index].icon == Icons.format_clear) {
                bool proceed = await widget.options.onButtonPressed?.call(ButtonType.clearFormatting, null, null) ?? true;
                if (proceed) {
                  widget.controller.execCommand('removeFormat');
                }
              }
            },
            isSelected: _fontSelected,
          ));
        }
        if (t.strikethrough || t.superscript || t.subscript) {
          toolbarChildren.add(ToggleButtons(
            constraints: BoxConstraints.tightFor(
              width: widget.options.toolbarItemHeight - 2,
              height: widget.options.toolbarItemHeight - 2,
            ),
            color: widget.options.buttonColor,
            selectedColor: widget.options.buttonSelectedColor,
            fillColor: widget.options.buttonFillColor,
            focusColor: widget.options.buttonFocusColor,
            highlightColor: widget.options.buttonHighlightColor,
            hoverColor: widget.options.buttonHoverColor,
            splashColor: widget.options.buttonSplashColor,
            selectedBorderColor: widget.options.buttonSelectedBorderColor,
            borderColor: widget.options.buttonBorderColor,
            borderRadius: widget.options.buttonBorderRadius,
            borderWidth: widget.options.buttonBorderWidth,
            renderBorder: widget.options.renderBorder,
            textStyle: widget.options.textStyle,
            children: t.getIcons2(),
            onPressed: (int index) async {
              void updateStatus() {
                setState(() {
                  _miscFontSelected[index] = !_miscFontSelected[index];
                });
              }

              if (t.getIcons2()[index].icon == Icons.format_strikethrough) {
                bool proceed = await widget.options.onButtonPressed?.call(ButtonType.strikethrough, _miscFontSelected[index], updateStatus) ?? true;
                if (proceed) {
                  widget.controller.execCommand('strikeThrough');
                  updateStatus();
                }
              }
              if (t.getIcons2()[index].icon == Icons.superscript) {
                bool proceed = await widget.options.onButtonPressed?.call(ButtonType.superscript, _miscFontSelected[index], updateStatus) ?? true;
                if (proceed) {
                  widget.controller.execCommand('superscript');
                  updateStatus();
                }
              }
              if (t.getIcons2()[index].icon == Icons.subscript) {
                bool proceed = await widget.options.onButtonPressed?.call(ButtonType.subscript, _miscFontSelected[index], updateStatus) ?? true;
                if (proceed) {
                  widget.controller.execCommand('subscript');
                  updateStatus();
                }
              }
            },
            isSelected: _miscFontSelected,
          ));
        }
      }
      if (t is ColorButtons) {
        toolbarChildren.add(ToggleButtons(
          constraints: BoxConstraints.tightFor(
            width: widget.options.toolbarItemHeight - 2,
            height: widget.options.toolbarItemHeight - 2,
          ),
          color: widget.options.buttonColor,
          selectedColor: widget.options.buttonSelectedColor,
          fillColor: widget.options.buttonFillColor,
          focusColor: widget.options.buttonFocusColor,
          highlightColor: widget.options.buttonHighlightColor,
          hoverColor: widget.options.buttonHoverColor,
          splashColor: widget.options.buttonSplashColor,
          selectedBorderColor: widget.options.buttonSelectedBorderColor,
          borderColor: widget.options.buttonBorderColor,
          borderRadius: widget.options.buttonBorderRadius,
          borderWidth: widget.options.buttonBorderWidth,
          renderBorder: widget.options.renderBorder,
          textStyle: widget.options.textStyle,
          children: t.getIcons(),
          onPressed: (int index) async {
            void updateStatus() {
              setState(() {
                _colorSelected[index] = !_colorSelected[index];
              });
            }

            if (_colorSelected[index]) {
              if (t.getIcons()[index].icon == Icons.format_color_text) {
                bool proceed = await widget.options.onButtonPressed?.call(ButtonType.foregroundColor, _colorSelected[index], updateStatus) ?? true;
                if (proceed) {
                  widget.controller.execCommand('foreColor',
                      argument: (Colors.black.value & 0xFFFFFF).toRadixString(16).padLeft(6, '0').toUpperCase());
                  updateStatus();
                }
              }
              if (t.getIcons()[index].icon == Icons.format_color_fill) {
                bool proceed = await widget.options.onButtonPressed?.call(ButtonType.highlightColor, _colorSelected[index], updateStatus) ?? true;
                if (proceed) {
                  widget.controller.execCommand('hiliteColor',
                      argument: (Colors.yellow.value & 0xFFFFFF).toRadixString(16).padLeft(6, '0').toUpperCase());
                  updateStatus();
                }
              }
            } else {
              bool proceed = true;
              if (t.getIcons()[index].icon == Icons.format_color_text) {
                proceed = await widget.options.onButtonPressed?.call(ButtonType.foregroundColor, _colorSelected[index], updateStatus) ?? true;
              } else if (t.getIcons()[index].icon == Icons.format_color_fill) {
                proceed = await widget.options.onButtonPressed?.call(ButtonType.highlightColor, _colorSelected[index], updateStatus) ?? true;
              }
              if (proceed) {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      late Color newColor;
                      if (t.getIcons()[index].icon == Icons.format_color_text)
                        newColor = _foreColorSelected;
                      else
                        newColor = _backColorSelected;
                      return PointerInterceptor(
                        child: AlertDialog(
                          title: Text('Pick ${t.getIcons()[index].icon == Icons.format_color_text ? "text" : "highlight"} color'),
                          content: SingleChildScrollView(
                            child: ColorPicker(
                              pickerColor: newColor,
                              paletteType: PaletteType.hsv,
                              enableAlpha: false,
                              displayThumbColor: true,
                              onColorChanged: (Color changed) {
                                newColor = changed;
                              },
                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text("Cancel"),
                            ),
                            TextButton(
                                onPressed: () {
                                  if (t.getIcons()[index].icon == Icons.format_color_text) {
                                    setState(() {
                                      _foreColorSelected = Colors.black;
                                    });
                                    widget.controller.execCommand('removeFormat', argument: 'foreColor');
                                    widget.controller.execCommand('foreColor', argument: 'initial');
                                  }
                                  if (t.getIcons()[index].icon == Icons.format_color_fill) {
                                    setState(() {
                                      _backColorSelected = Colors.yellow;
                                    });
                                    widget.controller.execCommand('removeFormat', argument: 'hiliteColor');
                                    widget.controller.execCommand('hiliteColor', argument: 'initial');
                                  }
                                  Navigator.of(context).pop();
                                },
                                child: Text("Reset to default color")
                            ),
                            TextButton(
                              onPressed: () {
                                if (t.getIcons()[index].icon == Icons.format_color_text) {
                                  widget.controller.execCommand('foreColor',
                                      argument: (newColor.value & 0xFFFFFF).toRadixString(16).padLeft(6, '0').toUpperCase());
                                  setState(() {
                                    _foreColorSelected = newColor;
                                  });
                                }
                                if (t.getIcons()[index].icon == Icons.format_color_fill) {
                                  widget.controller.execCommand('hiliteColor',
                                      argument: (newColor.value & 0xFFFFFF).toRadixString(16).padLeft(6, '0').toUpperCase());
                                  setState(() {
                                    _backColorSelected = newColor;
                                  });
                                }
                                setState(() {
                                  _colorSelected[index] = !_colorSelected[index];
                                });
                                Navigator.of(context).pop();
                              },
                              child: Text("Set color"),
                            )
                          ],
                        ),
                      );
                    }
                );
              }
            }
          },
          isSelected: _colorSelected,
        ));
      }
      if (t is ListButtons) {
        if (t.ul || t.ol) {
          toolbarChildren.add(ToggleButtons(
            constraints: BoxConstraints.tightFor(
              width: widget.options.toolbarItemHeight - 2,
              height: widget.options.toolbarItemHeight - 2,
            ),
            color: widget.options.buttonColor,
            selectedColor: widget.options.buttonSelectedColor,
            fillColor: widget.options.buttonFillColor,
            focusColor: widget.options.buttonFocusColor,
            highlightColor: widget.options.buttonHighlightColor,
            hoverColor: widget.options.buttonHoverColor,
            splashColor: widget.options.buttonSplashColor,
            selectedBorderColor: widget.options.buttonSelectedBorderColor,
            borderColor: widget.options.buttonBorderColor,
            borderRadius: widget.options.buttonBorderRadius,
            borderWidth: widget.options.buttonBorderWidth,
            renderBorder: widget.options.renderBorder,
            textStyle: widget.options.textStyle,
            children: t.getIcons(),
            onPressed: (int index) async {
              void updateStatus() {
                setState(() {
                  _listSelected[index] = !_listSelected[index];
                });
              }

              if (t.getIcons()[index].icon == Icons.format_list_bulleted) {
                bool proceed = await widget.options.onButtonPressed?.call(ButtonType.ul, _listSelected[index], updateStatus) ?? true;
                if (proceed) {
                  widget.controller.execCommand('insertUnorderedList');
                  updateStatus();
                }
              }
              if (t.getIcons()[index].icon == Icons.format_list_numbered) {
                bool proceed = await widget.options.onButtonPressed?.call(ButtonType.ol, _listSelected[index], updateStatus) ?? true;
                if (proceed) {
                  widget.controller.execCommand('insertOrderedList');
                  updateStatus();
                }
              }
            },
            isSelected: _listSelected,
          ));
        }
        if (t.listStyles) {
          toolbarChildren.add(Container(
            padding: const EdgeInsets.only(left: 8.0),
            height: widget.options.toolbarItemHeight,
            decoration: !widget.options.renderBorder ? null :
            widget.options.dropdownBoxDecoration ?? BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                border: Border.all(color: ToggleButtonsTheme.of(context).borderColor ?? Colors.grey[800]!)
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                elevation: widget.options.dropdownElevation,
                icon: widget.options.dropdownIcon,
                iconEnabledColor: widget.options.dropdownIconColor,
                iconSize: widget.options.dropdownIconSize,
                itemHeight: widget.options.dropdownItemHeight,
                focusColor: widget.options.dropdownFocusColor,
                dropdownColor: widget.options.dropdownBackgroundColor,
                menuMaxHeight: widget.options.dropdownMenuMaxHeight,
                style: widget.options.textStyle,
                items: [
                  DropdownMenuItem(child: PointerInterceptor(child: Text("1. Numbered")), value: "decimal"),
                  DropdownMenuItem(child: PointerInterceptor(child: Text("a. Lower Alpha")), value: "lower-alpha"),
                  DropdownMenuItem(child: PointerInterceptor(child: Text("A. Upper Alpha")), value: "upper-alpha"),
                  DropdownMenuItem(child: PointerInterceptor(child: Text("i. Lower Roman")), value: "lower-roman"),
                  DropdownMenuItem(child: PointerInterceptor(child: Text("I. Upper Roman")), value: "upper-roman"),
                  DropdownMenuItem(child: PointerInterceptor(child: Text("• Disc")), value: "disc"),
                  DropdownMenuItem(child: PointerInterceptor(child: Text("○ Circle")), value: "circle"),
                  DropdownMenuItem(child: PointerInterceptor(child: Text("■ Square")), value: "square"),
                ],
                hint: Text("Select list style"),
                value: _listStyleSelectedItem,
                onChanged: (String? changed) async {
                  void updateSelectedItem(dynamic changed) {
                    if (changed is String) {
                      setState(() {
                        _listStyleSelectedItem = changed;
                      });
                    }
                  }

                  if (changed != null) {
                    bool proceed = await widget.options.onDropdownChanged?.call(DropdownType.listStyles, changed, updateSelectedItem) ?? true;
                    if (proceed) {
                      if (kIsWeb) {
                        widget.controller.changeListStyle(changed);
                      } else {
                        widget.controller.editorController!.evaluateJavascript(source: """
                               var \$focusNode = \$(window.getSelection().focusNode);
                               var \$parentList = \$focusNode.closest("div.note-editable ol, div.note-editable ul");
                               \$parentList.css("list-style-type", "$changed");
                            """);
                      }
                      updateSelectedItem(changed);
                    }
                  }
                },
              ),
            ),
          ));
        }
      }
      if (t is ParagraphButtons) {
        if (t.alignLeft || t.alignCenter || t.alignRight || t.alignJustify) {
          toolbarChildren.add(ToggleButtons(
            constraints: BoxConstraints.tightFor(
              width: widget.options.toolbarItemHeight - 2,
              height: widget.options.toolbarItemHeight - 2,
            ),
            color: widget.options.buttonColor,
            selectedColor: widget.options.buttonSelectedColor,
            fillColor: widget.options.buttonFillColor,
            focusColor: widget.options.buttonFocusColor,
            highlightColor: widget.options.buttonHighlightColor,
            hoverColor: widget.options.buttonHoverColor,
            splashColor: widget.options.buttonSplashColor,
            selectedBorderColor: widget.options.buttonSelectedBorderColor,
            borderColor: widget.options.buttonBorderColor,
            borderRadius: widget.options.buttonBorderRadius,
            borderWidth: widget.options.buttonBorderWidth,
            renderBorder: widget.options.renderBorder,
            textStyle: widget.options.textStyle,
            children: t.getIcons1(),
            onPressed: (int index) async {
              void updateStatus() {
                _alignSelected = List<bool>.filled(t.getIcons1().length, false);
                setState(() {
                  _alignSelected[index] = !_alignSelected[index];
                });
              }

              if (t.getIcons1()[index].icon == Icons.format_align_left) {
                bool proceed = await widget.options.onButtonPressed?.call(ButtonType.alignLeft, _alignSelected[index], updateStatus) ?? true;
                if (proceed) {
                  widget.controller.execCommand('justifyLeft');
                  updateStatus();
                }
              }
              if (t.getIcons1()[index].icon == Icons.format_align_center) {
                bool proceed = await widget.options.onButtonPressed?.call(ButtonType.alignCenter, _alignSelected[index], updateStatus) ?? true;
                if (proceed) {
                  widget.controller.execCommand('justifyCenter');
                  updateStatus();
                }
              }
              if (t.getIcons1()[index].icon == Icons.format_align_right) {
                bool proceed = await widget.options.onButtonPressed?.call(ButtonType.alignRight, _alignSelected[index], updateStatus) ?? true;
                if (proceed) {
                  widget.controller.execCommand('justifyRight');
                  updateStatus();
                }
              }
              if (t.getIcons1()[index].icon == Icons.format_align_justify) {
                bool proceed = await widget.options.onButtonPressed?.call(ButtonType.alignJustify, _alignSelected[index], updateStatus) ?? true;
                if (proceed) {
                  widget.controller.execCommand('justifyFull');
                  updateStatus();
                }
              }
            },
            isSelected: _alignSelected,
          ));
        }
        if (t.increaseIndent || t.decreaseIndent) {
          toolbarChildren.add(ToggleButtons(
            constraints: BoxConstraints.tightFor(
              width: widget.options.toolbarItemHeight - 2,
              height: widget.options.toolbarItemHeight - 2,
            ),
            color: widget.options.buttonColor,
            selectedColor: widget.options.buttonSelectedColor,
            fillColor: widget.options.buttonFillColor,
            focusColor: widget.options.buttonFocusColor,
            highlightColor: widget.options.buttonHighlightColor,
            hoverColor: widget.options.buttonHoverColor,
            splashColor: widget.options.buttonSplashColor,
            selectedBorderColor: widget.options.buttonSelectedBorderColor,
            borderColor: widget.options.buttonBorderColor,
            borderRadius: widget.options.buttonBorderRadius,
            borderWidth: widget.options.buttonBorderWidth,
            renderBorder: widget.options.renderBorder,
            textStyle: widget.options.textStyle,
            children: t.getIcons2(),
            onPressed: (int index) async {
              if (t.getIcons2()[index].icon == Icons.format_indent_increase) {
                bool proceed = await widget.options.onButtonPressed?.call(ButtonType.increaseIndent, null, null) ?? true;
                if (proceed) {
                  widget.controller.execCommand('indent');
                }
              }
              if (t.getIcons2()[index].icon == Icons.format_indent_decrease) {
                bool proceed = await widget.options.onButtonPressed?.call(ButtonType.decreaseIndent, null, null) ?? true;
                if (proceed) {
                  widget.controller.execCommand('outdent');
                }
              }
            },
            isSelected: List<bool>.filled(t.getIcons2().length, false),
          ));
        }
        if (t.lineHeight) {
          toolbarChildren.add(Container(
            padding: const EdgeInsets.only(left: 8.0),
            height: widget.options.toolbarItemHeight,
            decoration: !widget.options.renderBorder ? null :
            widget.options.dropdownBoxDecoration ?? BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                border: Border.all(color: ToggleButtonsTheme.of(context).borderColor ?? Colors.grey[800]!)
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<double>(
                elevation: widget.options.dropdownElevation,
                icon: widget.options.dropdownIcon,
                iconEnabledColor: widget.options.dropdownIconColor,
                iconSize: widget.options.dropdownIconSize,
                itemHeight: widget.options.dropdownItemHeight,
                focusColor: widget.options.dropdownFocusColor,
                dropdownColor: widget.options.dropdownBackgroundColor,
                menuMaxHeight: widget.options.dropdownMenuMaxHeight,
                style: widget.options.textStyle,
                items: [
                  DropdownMenuItem(child: PointerInterceptor(child: Text("1.0")), value: 1),
                  DropdownMenuItem(child: PointerInterceptor(child: Text("1.2")), value: 1.2),
                  DropdownMenuItem(child: PointerInterceptor(child: Text("1.4")), value: 1.4),
                  DropdownMenuItem(child: PointerInterceptor(child: Text("1.5")), value: 1.5),
                  DropdownMenuItem(child: PointerInterceptor(child: Text("1.6")), value: 1.6),
                  DropdownMenuItem(child: PointerInterceptor(child: Text("1.8")), value: 1.8),
                  DropdownMenuItem(child: PointerInterceptor(child: Text("2.0")), value: 2),
                  DropdownMenuItem(child: PointerInterceptor(child: Text("3.0")), value: 3),
                ],
                value: _lineHeightSelectedItem,
                onChanged: (double? changed) async {
                  void updateSelectedItem(dynamic changed) {
                    if (changed is double) {
                      setState(() {
                        _lineHeightSelectedItem = changed;
                      });
                    }
                  }

                  if (changed != null) {
                    bool proceed = await widget.options.onDropdownChanged?.call(DropdownType.lineHeight, changed, updateSelectedItem) ?? true;
                    if (proceed) {
                      if (kIsWeb) {
                        widget.controller.changeLineHeight(changed.toString());
                      } else {
                        widget.controller.editorController!.evaluateJavascript(source:"\$('#summernote-2').summernote('lineHeight', '$changed');");
                      }
                      updateSelectedItem(changed);
                    }
                  }
                },
              ),
            ),
          ));
        }
        if (t.textDirection) {
          toolbarChildren.add(ToggleButtons(
            constraints: BoxConstraints.tightFor(
              width: widget.options.toolbarItemHeight - 2,
              height: widget.options.toolbarItemHeight - 2,
            ),
            color: widget.options.buttonColor,
            selectedColor: widget.options.buttonSelectedColor,
            fillColor: widget.options.buttonFillColor,
            focusColor: widget.options.buttonFocusColor,
            highlightColor: widget.options.buttonHighlightColor,
            hoverColor: widget.options.buttonHoverColor,
            splashColor: widget.options.buttonSplashColor,
            selectedBorderColor: widget.options.buttonSelectedBorderColor,
            borderColor: widget.options.buttonBorderColor,
            borderRadius: widget.options.buttonBorderRadius,
            borderWidth: widget.options.buttonBorderWidth,
            renderBorder: widget.options.renderBorder,
            textStyle: widget.options.textStyle,
            children: [
              Icon(Icons.format_textdirection_l_to_r),
              Icon(Icons.format_textdirection_r_to_l),
            ],
            onPressed: (int index) async {
              void updateStatus() {
                _textDirectionSelected = List<bool>.filled(2, false);
                setState(() {
                  _textDirectionSelected[index] = !_textDirectionSelected[index];
                });
              }

              bool proceed = await widget.options.onButtonPressed?.call(index == 0 ? ButtonType.ltr : ButtonType.rtl, _alignSelected[index], updateStatus) ?? true;
              if (proceed) {
                if (kIsWeb) {
                  widget.controller.changeTextDirection(index == 0 ? "ltr" : "rtl");
                } else {
                  widget.controller.editorController!.evaluateJavascript(source: """
                  var s=document.getSelection();			
                  if(s==''){
                      document.execCommand("insertHTML", false, "<p dir='${index == 0 ? "ltr" : "rtl"}'></p>");
                  }else{
                      document.execCommand("insertHTML", false, "<div dir='${index == 0 ? "ltr" : "rtl"}'>"+ document.getSelection()+"</div>");
                  }
                """);
                }
                updateStatus();
              }
            },
            isSelected: _textDirectionSelected,
          ));
        }
        if (t.caseConverter) {
          toolbarChildren.add(Container(
            padding: const EdgeInsets.only(left: 8.0),
            height: widget.options.toolbarItemHeight,
            decoration: !widget.options.renderBorder ? null :
            widget.options.dropdownBoxDecoration ?? BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                border: Border.all(color: ToggleButtonsTheme.of(context).borderColor ?? Colors.grey[800]!)
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                elevation: widget.options.dropdownElevation,
                icon: widget.options.dropdownIcon,
                iconEnabledColor: widget.options.dropdownIconColor,
                iconSize: widget.options.dropdownIconSize,
                itemHeight: widget.options.dropdownItemHeight,
                focusColor: widget.options.dropdownFocusColor,
                dropdownColor: widget.options.dropdownBackgroundColor,
                menuMaxHeight: widget.options.dropdownMenuMaxHeight,
                style: widget.options.textStyle,
                items: [
                  DropdownMenuItem(child: PointerInterceptor(child: Text("lowercase")), value: "lower"),
                  DropdownMenuItem(child: PointerInterceptor(child: Text("Sentence case")), value: "sentence"),
                  DropdownMenuItem(child: PointerInterceptor(child: Text("Title Case")), value: "title"),
                  DropdownMenuItem(child: PointerInterceptor(child: Text("UPPERCASE")), value: "upper"),
                ],
                hint: Text("Change case"),
                value: null,
                onChanged: (String? changed) async {
                  if (changed != null) {
                    bool proceed = await widget.options.onDropdownChanged?.call(DropdownType.caseConverter, changed, null) ?? true;
                    if (proceed) {
                      if (kIsWeb) {
                        widget.controller.changeCase(changed);
                      } else {
                        widget.controller.editorController!.evaluateJavascript(source:"""
                          var selected = \$('#summernote-2').summernote('createRange');
                          if(selected.toString()){
                              var texto;
                              var count = 0;
                              var value = "$changed";
                              var nodes = selected.nodes();
                              for (var i=0; i< nodes.length; ++i) {
                                  if (nodes[i].nodeName == "#text") {
                                      count++;
                                      texto = nodes[i].nodeValue.toLowerCase();
                                      nodes[i].nodeValue = texto;
                                      if (value == 'upper') {
                                         nodes[i].nodeValue = texto.toUpperCase();
                                      }
                                      else if (value == 'sentence' && count==1) {
                                         nodes[i].nodeValue = texto.charAt(0).toUpperCase() + texto.slice(1).toLowerCase();
                                      } else if (value == 'title') {
                                        var sentence = texto.split(" ");
                                        for(var j = 0; j< sentence.length; j++){
                                           sentence[j] = sentence[j][0].toUpperCase() + sentence[j].slice(1);
                                        }
                                        nodes[i].nodeValue = sentence.join(" ");
                                      }
                                  }
                              }
                          }
                        """);
                      }
                    }
                  }
                },
              ),
            ),
          ));
        }
      }
      if (t is InsertButtons) {
        toolbarChildren.add(ToggleButtons(
          constraints: BoxConstraints.tightFor(
            width: widget.options.toolbarItemHeight - 2,
            height: widget.options.toolbarItemHeight - 2,
          ),
          color: widget.options.buttonColor,
          selectedColor: widget.options.buttonSelectedColor,
          fillColor: widget.options.buttonFillColor,
          focusColor: widget.options.buttonFocusColor,
          highlightColor: widget.options.buttonHighlightColor,
          hoverColor: widget.options.buttonHoverColor,
          splashColor: widget.options.buttonSplashColor,
          selectedBorderColor: widget.options.buttonSelectedBorderColor,
          borderColor: widget.options.buttonBorderColor,
          borderRadius: widget.options.buttonBorderRadius,
          borderWidth: widget.options.buttonBorderWidth,
          renderBorder: widget.options.renderBorder,
          textStyle: widget.options.textStyle,
          children: t.getIcons(),
          onPressed: (int index) async {
            if (t.getIcons()[index].icon == Icons.link) {
              bool proceed = await widget.options.onButtonPressed?.call(ButtonType.link, null, null) ?? true;
              if (proceed) {
                final TextEditingController text = TextEditingController();
                final TextEditingController url = TextEditingController();
                final FocusNode textFocus = FocusNode();
                final FocusNode urlFocus = FocusNode();
                final GlobalKey<FormState> formKey = GlobalKey<FormState>();
                bool openNewTab = false;
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return PointerInterceptor(
                        child: StatefulBuilder(
                            builder: (BuildContext context, StateSetter setState) {
                              return AlertDialog(
                                title: Text("Insert Link"),
                                content: Form(
                                  key: formKey,
                                  child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("Text to display", style: TextStyle(fontWeight: FontWeight.bold)),
                                        SizedBox(height: 10),
                                        TextField(
                                          controller: text,
                                          focusNode: textFocus,
                                          textInputAction: TextInputAction.next,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(),
                                            hintText: "Text",
                                          ),
                                          onSubmitted: (_) {
                                            urlFocus.requestFocus();
                                          },
                                        ),
                                        SizedBox(height: 20),
                                        Text("URL", style: TextStyle(fontWeight: FontWeight.bold)),
                                        SizedBox(height: 10),
                                        TextFormField(
                                          controller: url,
                                          focusNode: urlFocus,
                                          textInputAction: TextInputAction.done,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(),
                                            hintText: "URL",
                                          ),
                                          validator: (String? value) {
                                            if (value == null || value.isEmpty) {
                                              return "Please enter a URL!";
                                            }
                                            return null;
                                          },
                                        ),
                                        Row(
                                          children: <Widget>[
                                            SizedBox(
                                              height: 48.0,
                                              width: 24.0,
                                              child: Checkbox(
                                                value: openNewTab,
                                                activeColor: Color(0xFF827250),
                                                onChanged: (bool? value) {
                                                  setState(() {
                                                    openNewTab = value!;
                                                  });
                                                },
                                              ),
                                            ),
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  primary: Theme.of(context).dialogBackgroundColor,
                                                  padding: EdgeInsets.only(left: 5, right: 5),
                                                  elevation: 0.0
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  openNewTab = !openNewTab;
                                                });
                                              },
                                              child: Text("Open in new window"),
                                            ),
                                          ],
                                        ),
                                      ]
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text("Cancel"),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      if (formKey.currentState!.validate()) {
                                        bool proceed = await widget.options
                                            .linkInsertInterceptor
                                            ?.call(text.text.isEmpty ? url.text : text.text, url.text, openNewTab) ?? true;
                                        if (proceed) {
                                          widget.controller.insertLink(
                                            text.text.isEmpty ? url.text : text.text,
                                            url.text,
                                            openNewTab,
                                          );
                                        }
                                        Navigator.of(context).pop();
                                      }
                                    },
                                    child: Text("OK"),
                                  )
                                ],
                              );
                            }
                        ),
                      );
                    }
                );
              }
            }
            if (t.getIcons()[index].icon == Icons.image_outlined) {
              bool proceed = await widget.options.onButtonPressed?.call(ButtonType.picture, null, null) ?? true;
              if (proceed) {
                final TextEditingController filename = TextEditingController();
                final TextEditingController url = TextEditingController();
                final FocusNode urlFocus = FocusNode();
                FilePickerResult? result;
                String? validateFailed;
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return PointerInterceptor(
                        child: StatefulBuilder(
                            builder: (BuildContext context, StateSetter setState) {
                              return AlertDialog(
                                title: Text("Insert Image"),
                                content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Select from files", style: TextStyle(fontWeight: FontWeight.bold)),
                                      SizedBox(height: 10),
                                      TextFormField(
                                          controller: filename,
                                          readOnly: true,
                                          decoration: InputDecoration(
                                            prefixIcon: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  primary: Theme.of(context).dialogBackgroundColor,
                                                  padding: EdgeInsets.only(left: 5, right: 5),
                                                  elevation: 0.0
                                              ),
                                              onPressed: () async {
                                                result = await FilePicker.platform.pickFiles(
                                                  type: FileType.image,
                                                  withData: true,
                                                  allowedExtensions: widget.options.imageExtensions,
                                                );
                                                if (result?.files.single.name != null) {
                                                  setState(() {
                                                    filename.text = result!.files.single.name!;
                                                  });
                                                }
                                              },
                                              child: Text("Choose image"),
                                            ),
                                            suffixIcon: result != null ?
                                            IconButton(
                                                icon: Icon(Icons.close),
                                                onPressed: () {
                                                  setState(() {
                                                    result = null;
                                                    filename.text = "";
                                                  });
                                                }
                                            ) : Container(height: 0, width: 0),
                                            errorText: validateFailed,
                                            errorMaxLines: 2,
                                            border: InputBorder.none,
                                          )
                                      ),
                                      SizedBox(height: 20),
                                      Text("URL", style: TextStyle(fontWeight: FontWeight.bold)),
                                      SizedBox(height: 10),
                                      TextField(
                                        controller: url,
                                        focusNode: urlFocus,
                                        textInputAction: TextInputAction.done,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                          hintText: "URL",
                                          errorText: validateFailed,
                                          errorMaxLines: 2,
                                        ),
                                      ),
                                    ]
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text("Cancel"),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      if (filename.text.isEmpty && url.text.isEmpty) {
                                        setState(() {
                                          validateFailed = "Please either choose an image or enter an image URL!";
                                        });
                                      } else if (filename.text.isNotEmpty && url.text.isNotEmpty) {
                                        setState(() {
                                          validateFailed = "Please input either an image or an image URL, not both!";
                                        });
                                      } else if (filename.text.isNotEmpty && result?.files.single.bytes != null) {
                                        String base64Data = base64.encode(result!.files.single.bytes!);
                                        bool proceed = await widget.options.mediaUploadInterceptor?.call(result!.files.single, InsertFileType.image) ?? true;
                                        if (proceed) {
                                          widget.controller.insertHtml(
                                              "<img src='data:image/${result!.files.single.extension};base64,$base64Data' data-filename='${result!.files.single.name}'/>");
                                        }
                                        Navigator.of(context).pop();
                                      } else {
                                        bool proceed = await widget.options.mediaLinkInsertInterceptor?.call(url.text, InsertFileType.image) ?? true;
                                        if (proceed) {
                                          widget.controller.insertNetworkImage(url.text);
                                        }
                                        Navigator.of(context).pop();
                                      }
                                    },
                                    child: Text("OK"),
                                  )
                                ],
                              );
                            }
                        ),
                      );
                    }
                );
              }
            }
            if (t.getIcons()[index].icon == Icons.audiotrack_outlined) {
              bool proceed = await widget.options.onButtonPressed?.call(ButtonType.audio, null, null) ?? true;
              if (proceed) {
                final TextEditingController filename = TextEditingController();
                final TextEditingController url = TextEditingController();
                final FocusNode urlFocus = FocusNode();
                FilePickerResult? result;
                String? validateFailed;
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return PointerInterceptor(
                        child: StatefulBuilder(
                            builder: (BuildContext context, StateSetter setState) {
                              return AlertDialog(
                                title: Text("Insert Audio"),
                                content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Select from files", style: TextStyle(fontWeight: FontWeight.bold)),
                                      SizedBox(height: 10),
                                      TextFormField(
                                          controller: filename,
                                          readOnly: true,
                                          decoration: InputDecoration(
                                            prefixIcon: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  primary: Theme.of(context).dialogBackgroundColor,
                                                  padding: EdgeInsets.only(left: 5, right: 5),
                                                  elevation: 0.0
                                              ),
                                              onPressed: () async {
                                                result = await FilePicker.platform.pickFiles(
                                                  type: FileType.audio,
                                                  withData: true,
                                                  allowedExtensions: widget.options.audioExtensions,
                                                );
                                                if (result?.files.single.name != null) {
                                                  setState(() {
                                                    filename.text = result!.files.single.name!;
                                                  });
                                                }
                                              },
                                              child: Text("Choose audio"),
                                            ),
                                            suffixIcon: result != null ?
                                            IconButton(
                                                icon: Icon(Icons.close),
                                                onPressed: () {
                                                  setState(() {
                                                    result = null;
                                                    filename.text = "";
                                                  });
                                                }
                                            ) : Container(height: 0, width: 0),
                                            errorText: validateFailed,
                                            errorMaxLines: 2,
                                            border: InputBorder.none,
                                          )
                                      ),
                                      SizedBox(height: 20),
                                      Text("URL", style: TextStyle(fontWeight: FontWeight.bold)),
                                      SizedBox(height: 10),
                                      TextField(
                                        controller: url,
                                        focusNode: urlFocus,
                                        textInputAction: TextInputAction.done,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                          hintText: "URL",
                                          errorText: validateFailed,
                                          errorMaxLines: 2,
                                        ),
                                      ),
                                    ]
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text("Cancel"),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      if (filename.text.isEmpty && url.text.isEmpty) {
                                        setState(() {
                                          validateFailed = "Please either choose an audio file or enter an audio file URL!";
                                        });
                                      } else if (filename.text.isNotEmpty && url.text.isNotEmpty) {
                                        setState(() {
                                          validateFailed = "Please input either an audio file or an audio URL, not both!";
                                        });
                                      } else if (filename.text.isNotEmpty && result?.files.single.bytes != null) {
                                        String base64Data = base64.encode(result!.files.single.bytes!);
                                        bool proceed = await widget.options.mediaUploadInterceptor?.call(result!.files.single, InsertFileType.audio) ?? true;
                                        if (proceed) {
                                          widget.controller.insertHtml(
                                              "<audio controls src='data:audio/${result!.files.single.extension};base64,$base64Data' data-filename='${result!.files.single.name}'></audio>");
                                        }
                                        Navigator.of(context).pop();
                                      } else {
                                        bool proceed = await widget.options.mediaLinkInsertInterceptor?.call(url.text, InsertFileType.audio) ?? true;
                                        if (proceed) {
                                          widget.controller.insertHtml("<audio controls src='${url.text}'></audio>");
                                        }
                                        Navigator.of(context).pop();
                                      }
                                    },
                                    child: Text("OK"),
                                  )
                                ],
                              );
                            }
                        ),
                      );
                    }
                );
              }
            }
            if (t.getIcons()[index].icon == Icons.videocam_outlined) {
              bool proceed = await widget.options.onButtonPressed?.call(ButtonType.video, null, null) ?? true;
              if (proceed) {
                final TextEditingController filename = TextEditingController();
                final TextEditingController url = TextEditingController();
                final FocusNode urlFocus = FocusNode();
                FilePickerResult? result;
                String? validateFailed;
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return PointerInterceptor(
                        child: StatefulBuilder(
                            builder: (BuildContext context, StateSetter setState) {
                              return AlertDialog(
                                title: Text("Insert Video"),
                                content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Select from files", style: TextStyle(fontWeight: FontWeight.bold)),
                                      SizedBox(height: 10),
                                      TextFormField(
                                          controller: filename,
                                          readOnly: true,
                                          decoration: InputDecoration(
                                            prefixIcon: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  primary: Theme.of(context).dialogBackgroundColor,
                                                  padding: EdgeInsets.only(left: 5, right: 5),
                                                  elevation: 0.0
                                              ),
                                              onPressed: () async {
                                                result = await FilePicker.platform.pickFiles(
                                                  type: FileType.video,
                                                  withData: true,
                                                  allowedExtensions: widget.options.videoExtensions,
                                                );
                                                if (result?.files.single.name != null) {
                                                  setState(() {
                                                    filename.text = result!.files.single.name!;
                                                  });
                                                }
                                              },
                                              child: Text("Choose video"),
                                            ),
                                            suffixIcon: result != null ?
                                            IconButton(
                                                icon: Icon(Icons.close),
                                                onPressed: () {
                                                  setState(() {
                                                    result = null;
                                                    filename.text = "";
                                                  });
                                                }
                                            ) : Container(height: 0, width: 0),
                                            errorText: validateFailed,
                                            errorMaxLines: 2,
                                            border: InputBorder.none,
                                          )
                                      ),
                                      SizedBox(height: 20),
                                      Text("URL", style: TextStyle(fontWeight: FontWeight.bold)),
                                      SizedBox(height: 10),
                                      TextField(
                                        controller: url,
                                        focusNode: urlFocus,
                                        textInputAction: TextInputAction.done,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                          hintText: "URL",
                                          errorText: validateFailed,
                                          errorMaxLines: 2,
                                        ),
                                      ),
                                    ]
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text("Cancel"),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      if (filename.text.isEmpty && url.text.isEmpty) {
                                        setState(() {
                                          validateFailed = "Please either choose a video or enter a video URL!";
                                        });
                                      } else if (filename.text.isNotEmpty && url.text.isNotEmpty) {
                                        setState(() {
                                          validateFailed = "Please input either a video or a video URL, not both!";
                                        });
                                      } else if (filename.text.isNotEmpty && result?.files.single.bytes != null) {
                                        String base64Data = base64.encode(result!.files.single.bytes!);
                                        bool proceed = await widget.options.mediaUploadInterceptor?.call(result!.files.single, InsertFileType.video) ?? true;
                                        if (proceed) {
                                          widget.controller.insertHtml(
                                              "<video controls src='data:video/${result!.files.single.extension};base64,$base64Data' data-filename='${result!.files.single.name}'></video>");
                                        }
                                        Navigator.of(context).pop();
                                      } else {
                                        bool proceed = await widget.options.mediaLinkInsertInterceptor?.call(url.text, InsertFileType.video) ?? true;
                                        if (proceed) {
                                          widget.controller.insertHtml("<video controls src='${url.text}'></video>");
                                        }
                                        Navigator.of(context).pop();
                                      }
                                    },
                                    child: Text("OK"),
                                  )
                                ],
                              );
                            }
                        ),
                      );
                    }
                );
              }
            }
            if (t.getIcons()[index].icon == Icons.attach_file) {
              bool proceed = await widget.options.onButtonPressed?.call(ButtonType.otherFile, null, null) ?? true;
              if (proceed) {
                final TextEditingController filename = TextEditingController();
                final TextEditingController url = TextEditingController();
                final FocusNode urlFocus = FocusNode();
                FilePickerResult? result;
                String? validateFailed;
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return PointerInterceptor(
                        child: StatefulBuilder(
                            builder: (BuildContext context, StateSetter setState) {
                              return AlertDialog(
                                title: Text("Insert File"),
                                content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Select from files", style: TextStyle(fontWeight: FontWeight.bold)),
                                      SizedBox(height: 10),
                                      TextFormField(
                                          controller: filename,
                                          readOnly: true,
                                          decoration: InputDecoration(
                                            prefixIcon: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  primary: Theme.of(context).dialogBackgroundColor,
                                                  padding: EdgeInsets.only(left: 5, right: 5),
                                                  elevation: 0.0
                                              ),
                                              onPressed: () async {
                                                result = await FilePicker.platform.pickFiles(
                                                  type: FileType.any,
                                                  withData: true,
                                                  allowedExtensions: widget.options.otherFileExtensions,
                                                );
                                                if (result?.files.single.name != null) {
                                                  setState(() {
                                                    filename.text = result!.files.single.name!;
                                                  });
                                                }
                                              },
                                              child: Text("Choose file"),
                                            ),
                                            suffixIcon: result != null ?
                                            IconButton(
                                                icon: Icon(Icons.close),
                                                onPressed: () {
                                                  setState(() {
                                                    result = null;
                                                    filename.text = "";
                                                  });
                                                }
                                            ) : Container(height: 0, width: 0),
                                            errorText: validateFailed,
                                            errorMaxLines: 2,
                                            border: InputBorder.none,
                                          )
                                      ),
                                      SizedBox(height: 20),
                                      Text("URL", style: TextStyle(fontWeight: FontWeight.bold)),
                                      SizedBox(height: 10),
                                      TextField(
                                        controller: url,
                                        focusNode: urlFocus,
                                        textInputAction: TextInputAction.done,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                          hintText: "URL",
                                          errorText: validateFailed,
                                          errorMaxLines: 2,
                                        ),
                                      ),
                                    ]
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text("Cancel"),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      if (filename.text.isEmpty && url.text.isEmpty) {
                                        setState(() {
                                          validateFailed = "Please either choose a file or enter a file URL!";
                                        });
                                      } else if (filename.text.isNotEmpty && url.text.isNotEmpty) {
                                        setState(() {
                                          validateFailed = "Please input either a file or a file URL, not both!";
                                        });
                                      } else if (filename.text.isNotEmpty && result?.files.single.bytes != null) {
                                        widget.options.onOtherFileUpload?.call(result!.files.single);
                                        Navigator.of(context).pop();
                                      } else {
                                        widget.options.onOtherFileLinkInsert?.call(url.text);
                                        Navigator.of(context).pop();
                                      }
                                    },
                                    child: Text("OK"),
                                  )
                                ],
                              );
                            }
                        ),
                      );
                    }
                );
              }
            }
            if (t.getIcons()[index].icon == Icons.table_chart_outlined) {
              bool proceed = await widget.options.onButtonPressed?.call(ButtonType.table, null, null) ?? true;
              if (proceed) {
                int currentRows = 1;
                int currentCols = 1;
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return PointerInterceptor(
                        child: StatefulBuilder(
                            builder: (BuildContext context, StateSetter setState) {
                              return AlertDialog(
                                title: Text("Insert Table"),
                                content: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      NumberPicker(
                                        value: currentRows,
                                        minValue: 1,
                                        maxValue: 10,
                                        onChanged: (value) => setState(() => currentRows = value),
                                      ),
                                      Text('x'),
                                      NumberPicker(
                                        value: currentCols,
                                        minValue: 1,
                                        maxValue: 10,
                                        onChanged: (value) => setState(() => currentCols = value),
                                      ),
                                    ]
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text("Cancel"),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      if (kIsWeb) {
                                        widget.controller.insertTable('${currentRows}x$currentCols');
                                      } else {
                                        widget.controller.editorController!.evaluateJavascript(source: "\$('#summernote-2').summernote('insertTable', '${currentRows}x$currentCols');");
                                      }
                                      Navigator.of(context).pop();
                                    },
                                    child: Text("OK"),
                                  )
                                ],
                              );
                            }
                        ),
                      );
                    }
                );
              }
            }
            if (t.getIcons()[index].icon == Icons.horizontal_rule) {
              bool proceed = await widget.options.onButtonPressed?.call(ButtonType.hr, null, null) ?? true;
              if (proceed) {
                widget.controller.insertHtml("<hr/>");
              }
            }
          },
          isSelected: List<bool>.filled(t.getIcons().length, false),
        ));
      }
      if (t is OtherButtons) {
        if (t.fullscreen || t.codeview || t.undo || t.redo || t.help) {
          toolbarChildren.add(ToggleButtons(
            constraints: BoxConstraints.tightFor(
              width: widget.options.toolbarItemHeight - 2,
              height: widget.options.toolbarItemHeight - 2,
            ),
            color: widget.options.buttonColor,
            selectedColor: widget.options.buttonSelectedColor,
            fillColor: widget.options.buttonFillColor,
            focusColor: widget.options.buttonFocusColor,
            highlightColor: widget.options.buttonHighlightColor,
            hoverColor: widget.options.buttonHoverColor,
            splashColor: widget.options.buttonSplashColor,
            selectedBorderColor: widget.options.buttonSelectedBorderColor,
            borderColor: widget.options.buttonBorderColor,
            borderRadius: widget.options.buttonBorderRadius,
            borderWidth: widget.options.buttonBorderWidth,
            renderBorder: widget.options.renderBorder,
            textStyle: widget.options.textStyle,
            children: t.getIcons1(),
            onPressed: (int index) async {
              void updateStatus() {
                setState(() {
                  _miscSelected[index] = !_miscSelected[index];
                });
              }

              if (t.getIcons1()[index].icon == Icons.fullscreen) {
                bool proceed = await widget.options.onButtonPressed?.call(ButtonType.fullscreen, _miscSelected[index], updateStatus) ?? true;
                if (proceed) {
                  widget.controller.setFullScreen();
                  updateStatus();
                }
              }
              if (t.getIcons1()[index].icon == Icons.code) {
                bool proceed = await widget.options.onButtonPressed?.call(ButtonType.codeview, _miscSelected[index], updateStatus) ?? true;
                if (proceed) {
                  widget.controller.toggleCodeView();
                  updateStatus();
                }
              }
              if (t.getIcons1()[index].icon == Icons.undo) {
                bool proceed = await widget.options.onButtonPressed?.call(ButtonType.undo, null, null) ?? true;
                if (proceed) {
                  widget.controller.undo();
                }
              }
              if (t.getIcons1()[index].icon == Icons.redo) {
                bool proceed = await widget.options.onButtonPressed?.call(ButtonType.redo, null, null) ?? true;
                if (proceed) {
                  widget.controller.redo();
                }
              }
              if (t.getIcons1()[index].icon == Icons.help_outline) {
                bool proceed = await widget.options.onButtonPressed?.call(ButtonType.help, null, null) ?? true;
                if (proceed) {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return PointerInterceptor(
                          child: StatefulBuilder(
                              builder: (BuildContext context, StateSetter setState) {
                                return AlertDialog(
                                  title: Text("Help"),
                                  content: Container(
                                    height: MediaQuery.of(context).size.height / 2,
                                    child: SingleChildScrollView(
                                      child: DataTable(
                                        columnSpacing: 5,
                                        dataRowHeight: 75,
                                        columns: const <DataColumn>[
                                          DataColumn(
                                            label: Text(
                                              'Key Combination',
                                              style: TextStyle(fontStyle: FontStyle.italic),
                                            ),
                                          ),
                                          DataColumn(
                                            label: Text(
                                              'Action',
                                              style: TextStyle(fontStyle: FontStyle.italic),
                                            ),
                                          ),
                                        ],
                                        rows: const <DataRow>[
                                          DataRow(
                                            cells: <DataCell>[
                                              DataCell(Text('ESC')),
                                              DataCell(Text('Escape')),
                                            ],
                                          ),
                                          DataRow(
                                            cells: <DataCell>[
                                              DataCell(Text('ENTER')),
                                              DataCell(Text('Insert Paragraph')),
                                            ],
                                          ),
                                          DataRow(
                                            cells: <DataCell>[
                                              DataCell(Text('CTRL+Z')),
                                              DataCell(Text('Undo the last command')),
                                            ],
                                          ),
                                          DataRow(
                                            cells: <DataCell>[
                                              DataCell(Text('CTRL+Z')),
                                              DataCell(Text('Undo the last command')),
                                            ],
                                          ),
                                          DataRow(
                                            cells: <DataCell>[
                                              DataCell(Text('CTRL+Y')),
                                              DataCell(Text('Redo the last command')),
                                            ],
                                          ),
                                          DataRow(
                                            cells: <DataCell>[
                                              DataCell(Text('TAB')),
                                              DataCell(Text('Tab')),
                                            ],
                                          ),
                                          DataRow(
                                            cells: <DataCell>[
                                              DataCell(Text('SHIFT+TAB')),
                                              DataCell(Text('Untab')),
                                            ],
                                          ),
                                          DataRow(
                                            cells: <DataCell>[
                                              DataCell(Text('CTRL+B')),
                                              DataCell(Text('Set a bold style')),
                                            ],
                                          ),
                                          DataRow(
                                            cells: <DataCell>[
                                              DataCell(Text('CTRL+I')),
                                              DataCell(Text('Set an italic style')),
                                            ],
                                          ),
                                          DataRow(
                                            cells: <DataCell>[
                                              DataCell(Text('CTRL+U')),
                                              DataCell(Text('Set an underline style')),
                                            ],
                                          ),
                                          DataRow(
                                            cells: <DataCell>[
                                              DataCell(Text('CTRL+SHIFT+S')),
                                              DataCell(Text('Set a strikethrough style')),
                                            ],
                                          ),
                                          DataRow(
                                            cells: <DataCell>[
                                              DataCell(Text('CTRL+BACKSLASH')),
                                              DataCell(Text('Clean a style')),
                                            ],
                                          ),
                                          DataRow(
                                            cells: <DataCell>[
                                              DataCell(Text('CTRL+SHIFT+L')),
                                              DataCell(Text('Set left align')),
                                            ],
                                          ),
                                          DataRow(
                                            cells: <DataCell>[
                                              DataCell(Text('CTRL+SHIFT+E')),
                                              DataCell(Text('Set center align')),
                                            ],
                                          ),
                                          DataRow(
                                            cells: <DataCell>[
                                              DataCell(Text('CTRL+SHIFT+R')),
                                              DataCell(Text('Set right align')),
                                            ],
                                          ),
                                          DataRow(
                                            cells: <DataCell>[
                                              DataCell(Text('CTRL+SHIFT+J')),
                                              DataCell(Text('Set full align')),
                                            ],
                                          ),
                                          DataRow(
                                            cells: <DataCell>[
                                              DataCell(Text('CTRL+SHIFT+NUM7')),
                                              DataCell(Text('Toggle unordered list')),
                                            ],
                                          ),
                                          DataRow(
                                            cells: <DataCell>[
                                              DataCell(Text('CTRL+SHIFT+NUM8')),
                                              DataCell(Text('Toggle ordered list')),
                                            ],
                                          ),
                                          DataRow(
                                            cells: <DataCell>[
                                              DataCell(Text('CTRL+LEFTBRACKET')),
                                              DataCell(Text('Outdent on current paragraph')),
                                            ],
                                          ),
                                          DataRow(
                                            cells: <DataCell>[
                                              DataCell(Text('CTRL+RIGHTBRACKET')),
                                              DataCell(Text('Indent on current paragraph')),
                                            ],
                                          ),
                                          DataRow(
                                            cells: <DataCell>[
                                              DataCell(Text('CTRL+NUM0')),
                                              DataCell(Text('Change current block\'s format as a paragraph (<p> tag)')),
                                            ],
                                          ),
                                          DataRow(
                                            cells: <DataCell>[
                                              DataCell(Text('CTRL+NUM1')),
                                              DataCell(Text('Change current block\'s format as H1')),
                                            ],
                                          ),
                                          DataRow(
                                            cells: <DataCell>[
                                              DataCell(Text('CTRL+NUM2')),
                                              DataCell(Text('Change current block\'s format as H2')),
                                            ],
                                          ),
                                          DataRow(
                                            cells: <DataCell>[
                                              DataCell(Text('CTRL+NUM3')),
                                              DataCell(Text('Change current block\'s format as H3')),
                                            ],
                                          ),
                                          DataRow(
                                            cells: <DataCell>[
                                              DataCell(Text('CTRL+NUM4')),
                                              DataCell(Text('Change current block\'s format as H4')),
                                            ],
                                          ),
                                          DataRow(
                                            cells: <DataCell>[
                                              DataCell(Text('CTRL+NUM5')),
                                              DataCell(Text('Change current block\'s format as H5')),
                                            ],
                                          ),
                                          DataRow(
                                            cells: <DataCell>[
                                              DataCell(Text('CTRL+NUM6')),
                                              DataCell(Text('Change current block\'s format as H6')),
                                            ],
                                          ),
                                          DataRow(
                                            cells: <DataCell>[
                                              DataCell(Text('CTRL+ENTER')),
                                              DataCell(Text('Insert horizontal rule')),
                                            ],
                                          ),
                                          DataRow(
                                            cells: <DataCell>[
                                              DataCell(Text('CTRL+K')),
                                              DataCell(Text('Show link dialog')),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () async {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text("Close"),
                                    )
                                  ],
                                );
                              }
                          ),
                        );
                      }
                  );
                }
              }
            },
            isSelected: _miscSelected,
          ));
        }
        if (t.copy || t.paste) {
          toolbarChildren.add(ToggleButtons(
            constraints: BoxConstraints.tightFor(
              width: widget.options.toolbarItemHeight - 2,
              height: widget.options.toolbarItemHeight - 2,
            ),
            color: widget.options.buttonColor,
            selectedColor: widget.options.buttonSelectedColor,
            fillColor: widget.options.buttonFillColor,
            focusColor: widget.options.buttonFocusColor,
            highlightColor: widget.options.buttonHighlightColor,
            hoverColor: widget.options.buttonHoverColor,
            splashColor: widget.options.buttonSplashColor,
            selectedBorderColor: widget.options.buttonSelectedBorderColor,
            borderColor: widget.options.buttonBorderColor,
            borderRadius: widget.options.buttonBorderRadius,
            borderWidth: widget.options.buttonBorderWidth,
            renderBorder: widget.options.renderBorder,
            textStyle: widget.options.textStyle,
            children: t.getIcons2(),
            onPressed: (int index) async {
              if (t.getIcons2()[index].icon == Icons.copy) {
                bool proceed = await widget.options.onButtonPressed?.call(ButtonType.copy, null, null) ?? true;
                if (proceed) {
                  String? data = await widget.controller.getText();
                  Clipboard.setData(new ClipboardData(text: data));
                }
              }
              if (t.getIcons2()[index].icon == Icons.paste) {
                bool proceed = await widget.options.onButtonPressed?.call(ButtonType.paste, null, null) ?? true;
                if (proceed) {
                  ClipboardData? data = await Clipboard.getData(Clipboard.kTextPlain);
                  if (data != null) {
                    String text = data.text!;
                    widget.controller.insertHtml(text);
                  }
                }
              }
            },
            isSelected: List<bool>.filled(t.getIcons2().length, false),
          ));
        }
      }
    }
    if (widget.options.customToolbarInsertionIndices.isNotEmpty
        && widget.options.customToolbarInsertionIndices.length == widget.options.customToolbarButtons.length) {
      for (int i = 0; i < widget.options.customToolbarInsertionIndices.length; i++) {
        if (widget.options.customToolbarInsertionIndices[i] > toolbarChildren.length) {
          toolbarChildren.insert(toolbarChildren.length, widget.options.customToolbarButtons[i]);
        } else if (widget.options.customToolbarInsertionIndices[i] < 0) {
          toolbarChildren.insert(0, widget.options.customToolbarButtons[i]);
        } else {
          toolbarChildren.insert(widget.options.customToolbarInsertionIndices[i], widget.options.customToolbarButtons[i]);
        }
      }
    } else {
      toolbarChildren.addAll(widget.options.customToolbarButtons);
    }
    if (widget.options.renderSeparatorWidget)
      toolbarChildren = intersperse(widget.options.separatorWidget, toolbarChildren).toList();
    return toolbarChildren;
  }
}

// courtesy of @modulovalue (https://github.com/modulovalue/dart_intersperse/blob/master/lib/src/intersperse.dart)
Iterable<T> intersperse<T>(T element, Iterable<T> iterable) sync* {
  final iterator = iterable.iterator;
  if (iterator.moveNext()) {
    yield iterator.current;
    while (iterator.moveNext()) {
      yield element;
      yield iterator.current;
    }
  }
}
