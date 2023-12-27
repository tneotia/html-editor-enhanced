import 'package:flutter/material.dart';
import 'package:html_editor_enhanced_fork_latex/html_editor.dart';

class EditorWithFocusChange extends StatefulWidget {
  const EditorWithFocusChange();

  @override
  createState() => _EditorWithFocusChangeState();
}

class _EditorWithFocusChangeState extends State<EditorWithFocusChange> {
  final HtmlEditorController controller = HtmlEditorController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        VisibleToolbar(controller: controller),
        HtmlEditor(
          controller: controller,
          htmlEditorOptions: HtmlEditorOptions(
            hint: 'Your text here...',
            shouldEnsureVisible: true,
            //initialText: "<p>text content initial, if any</p>",
          ),
          htmlToolbarOptions: HtmlToolbarOptions(
            toolbarPosition: ToolbarPosition.custom,
            // toolbarType: ToolbarType.nativeScrollable,
            // onButtonPressed:
            //     (ButtonType type, bool? status, Function? updateStatus) {
            //   print(
            //       "button '${(type.name)}' pressed, the current selected status is $status");
            //   return true;
            // },
            // onDropdownChanged: (DropdownType type, dynamic changed,
            //     Function(dynamic)? updateSelectedItem) {
            //   print("dropdown '${(type.name)}' changed to $changed");
            //   return true;
            // },
            // mediaLinkInsertInterceptor: (String url, InsertFileType type) {
            //   print(url);
            //   return true;
            // },
            // mediaUploadInterceptor: (PlatformFile file, InsertFileType type) async {
            //   print(file.name); //filename
            //   print(file.size); //size in bytes
            //   print(file.extension); //file extension (eg jpeg or mp4)
            //   return true;
            // },
          ),
          otherOptions: OtherOptions(height: 550),
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
              },
            ),
          ],
        ),
      ],
    );
  }
}

class VisibleToolbar extends StatefulWidget {
  const VisibleToolbar({required this.controller});

  final HtmlEditorController controller;

  @override
  State<VisibleToolbar> createState() => _VisibleToolbarState();
}

class _VisibleToolbarState extends State<VisibleToolbar> {
  bool _isVisible = false;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: _isVisible,
      child: ToolbarWidget(
        controller: widget.controller,
        htmlToolbarOptions: HtmlToolbarOptions(
          toolbarPosition: ToolbarPosition.custom,
          toolbarType: ToolbarType.nativeScrollable,
          defaultToolbarButtons: const [
            StyleButtons(),
            FontSettingButtons(fontSizeUnit: false, fontName: false),
            FontButtons(clearAll: false),
            ColorButtons(highlightColor: false),
            ListButtons(listStyles: false),
            ParagraphButtons(
                textDirection: false,
                lineHeight: false,
                caseConverter: false,
                alignJustify: false),
            InsertButtons(
                video: false,
                link: false,
                audio: false,
                table: true,
                hr: true,
                otherFile: false),
          ],
        ),
        callbacks: Callbacks(
          onBeforeCommand: (String? currentHtml) {
            print('html before change is $currentHtml');
          },
          onChangeContent: (String? changed) {
            print('content changed to $changed');
          },
          onChangeCodeview: (String? changed) {
            print('code changed to $changed');
          },
          onChangeSelection: (EditorSettings settings) {
            print('parent element is ${settings.parentElement}');
            print('font name is ${settings.fontName}');
          },
          onDialogShown: () {
            print('dialog shown');
          },
          onEnter: () {
            print('enter/return pressed');
          },
          onFocus: () {
            setState(() {
              _isVisible = true;
            });
            print('editor focused');
          },
          onBlur: () {
            setState(() {
              _isVisible = false;
            });
            print('editor unfocused');
          },
          onBlurCodeview: () {
            print('codeview either focused or unfocused');
          },
          onInit: () {
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
          },
          onKeyDown: (int? keyCode) {
            print('$keyCode key downed');
            print(
                'current character count: ${widget.controller.characterCount}');
          },
          onKeyUp: (int? keyCode) {
            print('$keyCode key released');
          },
          onMouseDown: () {
            print('mouse downed');
          },
          onMouseUp: () {
            print('mouse released');
          },
          onNavigationRequestMobile: (String url) {
            print(url);
            return NavigationActionPolicy.ALLOW;
          },
          onPaste: () {
            print('pasted into editor');
          },
          onScroll: () {
            print('editor scrolled');
          },
        ),
      ),
    );
  }
}
