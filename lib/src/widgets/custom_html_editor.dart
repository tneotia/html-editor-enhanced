// ignore_for_file: avoid_print

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../html_editor.dart';

class CustomHtmlEditorWidget extends StatelessWidget {
  const CustomHtmlEditorWidget({required this.controller, double? height})
      : _height = height ?? 500;
  final HtmlEditorController controller;
  final double _height;

  Widget _htmlWidget() {
    return HtmlEditor(
      controller: controller,
      htmlEditorOptions: const HtmlEditorOptions(
        hint: 'Your text here...',
        shouldEnsureVisible: true,
        //initialText: "<p>text content initial, if any</p>",
      ),
      htmlToolbarOptions: HtmlToolbarOptions(
        toolbarPosition: ToolbarPosition.aboveEditor,
        defaultToolbarButtons: [
          const StyleButtons(),
          const FontSettingButtons(fontSizeUnit: false),
          const FontButtons(clearAll: false),
          const ColorButtons(),
          const ListButtons(listStyles: false),
          const ParagraphButtons(
              textDirection: false, lineHeight: false, caseConverter: false),
          const InsertButtons(
              video: false,
              audio: false,
              table: true,
              hr: true,
              fn: true,
              otherFile: false),
        ],
        //by default
        toolbarType: ToolbarType.nativeExpandable,
        //by default
        onButtonPressed:
            (ButtonType type, bool? status, Function? updateStatus) {
          if (type.name == ButtonType.picture.name) {
            print('no image');
            controller.insertHtml(tableTex);
            return false;
          }
          print(
              "button '${type.name}' pressed, the current selected status is $status");
          return true;
        },
        onDropdownChanged: (DropdownType type, dynamic changed,
            Function(dynamic)? updateSelectedItem) {
          print("dropdown '${type.name}' changed to $changed");
          return true;
        },
        mediaLinkInsertInterceptor: (String url, InsertFileType type) {
          print(url);
          return true;
        },
        mediaUploadInterceptor: (PlatformFile file, InsertFileType type) async {
          if (kDebugMode) {
            print(file.name);
          } //filename
          print(file.size); //size in bytes
          print(file.extension); //file extension (eg jpeg or mp4)
          return true;
        },
      ),
      otherOptions: OtherOptions(height: _height),
      callbacks: Callbacks(onBeforeCommand: (String? currentHtml) {
        print('html before change is $currentHtml');
      }, onChangeContent: (String? changed) {
        print('content changed to $changed');
      }, onChangeCodeview: (String? changed) {
        print('code changed to $changed');
      }, onChangeSelection: (EditorSettings settings) {
        print('parent element is ${settings.parentElement}');
        print('font name is ${settings.fontName}');
      }, onDialogShown: () {
        print('dialog shown');
      }, onEnter: () {
        print('enter/return pressed');
      }, onFocus: () {
        print('editor focused');
      }, onBlur: () {
        print('editor unfocused');
      }, onBlurCodeview: () {
        print('codeview either focused or unfocused');
      }, onInit: () {
        print('init');
      },
          //this is commented because it overrides the default Summernote handlers
          /*onImageLinkInsert: (String? url) {
                    print(url ?? "unknown url");
                  },
                  onImageUpload: (FileUpload file) async {
                    print(file.name);
                    print(file.size);
                    print(file.type);
                    print(file.base64);
                  },*/
          onImageUploadError:
              (FileUpload? file, String? base64Str, UploadError error) {
        print((error.name));
        print(base64Str ?? '');
        if (file != null) {
          print(file.name);
          print(file.size);
          print(file.type);
        }
      }, onKeyDown: (int? keyCode) {
        print('$keyCode key downed');
        print('current character count: ${controller.characterCount}');
      }, onKeyUp: (int? keyCode) {
        print('$keyCode key released');
      }, onMouseDown: () {
        print('mouse downed');
      }, onMouseUp: () {
        print('mouse released');
      }, onNavigationRequestMobile: (String url) {
        print(url);
        return NavigationActionPolicy.ALLOW;
      }, onPaste: () {
        print('pasted into editor');
      }, onScroll: () {
        print('editor scrolled');
      }),
      plugins: [
        SummernoteAtMention(
            getSuggestionsMobile: (String value) {
              var mentions = <String>['test1', 'test2', 'test3'];
              return mentions
                  .where((element) => element.contains(value))
                  .toList();
            },
            mentionsWeb: ['test1', 'test2', 'test3'],
            onSelect: (String value) {
              print(value);
            }),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _htmlWidget();
  }
}

const tableTex = r'''
  <tex>
  \begin{array} { | l | l | l | } 
\hline \text { Year } & \begin{array} { l } 
\text { Number of U.S. } \\
\text { farms (in } \\
\text { millions) }
\end{array} & \begin{array} { l } 
\text { Average size of } \\
\text { U.S. farms } \\
\text { (acres) }
\end{array} \\
\hline 1950 & 5.6 & 234 \\
\hline 1960 & 4.0 & 330 \\
\hline 1970 & 2.9 & 399 \\
\hline 1980 & 2.4 & 441 \\
\hline 1990 & 2.1 & 478 \\
\hline 2000 & 2.2 & 439 \\
\hline
\end{array}</tex>
  ''';
