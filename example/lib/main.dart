import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:html_editor_enhanced/src/models/text_highlight.dart';
import 'package:html_editor_enhanced/src/models/parsed_highlight.dart';

void main() => runApp(HtmlEditorExampleApp());

class HtmlEditorExampleApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(),
      darkTheme: ThemeData.dark(),
      home: HtmlEditorExample(title: 'Flutter HTML Editor Example'),
    );
  }
}

class HtmlEditorExample extends StatefulWidget {
  HtmlEditorExample({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _HtmlEditorExampleState createState() => _HtmlEditorExampleState();
}

class _HtmlEditorExampleState extends State<HtmlEditorExample> {
  String result = '';
  List<ParsedHighlight> highlights = [];
  final HtmlEditorController controller = HtmlEditorController();

  @override
  void initState() {
    controller.onTextHighlightsReplacersReady = (parsedData) {
      highlights = parsedData;
      setState(() {});
    };
    controller.setHighlights([
      TextHighLight(text: 'Kotlin'),
      TextHighLight(text: 'Actively'),
      TextHighLight(text: 'Flutter'),
      TextHighLight(text: 'Swift'),
      TextHighLight(text: 'mobile'),
      TextHighLight(text: 'Ionic'),
      TextHighLight(text: 'in'),
      TextHighLight(text: 'A'),
      TextHighLight(text: 'technologies',css: {
        "background-color":"green !important"
      }),
    ]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!kIsWeb) {
          controller.clearFocus();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          elevation: 0,
          actions: [
            IconButton(
                icon: Icon(Icons.refresh),
                onPressed: () async {
                  //controller.clear();
                  controller.insertText('A full-stack web & mobile developer with experience in web and mobile development technologies. Actively involved in tech communities as a speaker & mentor. technologies  Started with Web Progressing towards mobile development and has worked technologies with iOS (using Swift), Android (Kotlin & Java), Ionic, React Native, Flutter, and many other platforms with various types of languages and frameworks. Ahsan is very good man');
                  await Future.delayed(Duration(milliseconds: 1000));
                  /*if (kIsWeb) {
                    controller.reloadWeb();
                  } else {
                    controller.editorController!.reload();
                  }*/
                  controller.setHighlights([
                    TextHighLight(text: 'Kotlin',onTap: (h,r) {
                      print("as");
                    }),
                    TextHighLight(text: 'Actively',onTap: (h,r){
                      print("as");
                    }),
                    TextHighLight(text: 'Flutter',onTap: (h,r){
                      print("as");
                    }),
                    TextHighLight(text: 'Swift',onTap: (h,r){
                      print("as");
                    }),
                    //TextHighLight(text: 'mobile'),
                    TextHighLight(text: 'Ionic',onTap: (h,r){
                      highlights[highlights.indexOf(h)].replacer!('CHEETAH KAAM HGYA');
                      print("as");
                    }),
                    TextHighLight(text: 'in web and mobile',onTap: (highlight, replacer) {
                      //replacer('SHIT HAPPENS');
                      //highlights[highlights.indexOf(highlight)].replacer!('CHEETAH KAAM HGYA');
                      print('HOGYAA1====================================================');
                    }),
                    TextHighLight(text: 'A',onTap: (h,r){
                      print("as");
                    }),
                    TextHighLight(text: 'technologies',css: {
                      "background-color":"green !important"
                    },onTap: (highlight, replacer) {
                      replacer('WOW');
                      print('HOGYAA2====================================================');
                    }),
                  ]);
                })
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            controller.toggleCodeView();
          },
          child: Text(r'<\>', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: HtmlEditor(
                controller: controller,
                htmlEditorOptions: const HtmlEditorOptions(hint: "Start writing your job description here or <strong>upload pdf</strong>", initialText: "", adjustHeightForKeyboard: true),
                otherOptions: const OtherOptions(decoration: BoxDecoration(border: null)),
                callbacks: Callbacks(onWebViewReady: () {

                },onFocus: () {
                  print("Hello world");
                }),
                htmlToolbarOptions: const HtmlToolbarOptions(
                    renderSeparatorWidget: false,
                    toolbarType: ToolbarType.nativeGrid,
                    customToolbarButtons: [],
                    defaultToolbarButtons: [
                      //     clearAll: false,
                      //     strikethrough: false,
                      //     superscript: false,
                      //     subscript: false),
                      // ListButtons(listStyles: false)
                      // FontButtons(
                    ],
                    toolbarItemHeight: 0,
                    gridViewHorizontalSpacing: 0,
                    gridViewVerticalSpacing: 0,
                    toolbarPosition: ToolbarPosition.belowEditor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
