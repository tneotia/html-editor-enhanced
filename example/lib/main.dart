import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:html_editor_enhanced/html_editor.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(),
      darkTheme: ThemeData.dark(),
      home: MyHomePage(title: 'Flutter HTML Editor Example'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String result = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        elevation: 0,
        actions: [
          IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                if (kIsWeb) {
                  HtmlEditor.reloadWeb();
                } else {
                  HtmlEditor.editorController.reload();
                }
              })
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Text("\<\\\>",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        onPressed: () {
          HtmlEditor.toggleCodeView();
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            HtmlEditor(
                hint: "Your text here...",
                //value: "text content initial, if any",
                height: 400,
                callbacks: Callbacks(
                  onChange: (String changed) {
                    print("content changed to $changed");
                  },
                  onEnter: () {
                    print("enter/return pressed");
                  },
                  onFocus: () {
                    print("editor focused");
                  },
                  onBlur: () {
                    print("editor unfocused");
                  },
                  onBlurCodeview: () {
                    print("codeview either focused or unfocused");
                  },
                  onKeyDown: (keyCode) {
                    print("$keyCode key downed");
                  },
                  onKeyUp: (keyCode) {
                    print("$keyCode key released");
                  },
                  onPaste: () {
                    print("pasted into editor");
                  },
                )),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextButton(
                    style:
                        TextButton.styleFrom(backgroundColor: Colors.blueGrey),
                    onPressed: () {
                      HtmlEditor.undo();
                    },
                    child: Text("Undo", style: TextStyle(color: Colors.white)),
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  TextButton(
                    style:
                        TextButton.styleFrom(backgroundColor: Colors.blueGrey),
                    onPressed: () {
                      HtmlEditor.clear();
                    },
                    child: Text("Reset", style: TextStyle(color: Colors.white)),
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                        backgroundColor: Theme.of(context).accentColor),
                    onPressed: () async {
                      String txt = await HtmlEditor.getText();
                      if (txt.contains("<img src=\"data:image")) {
                        txt =
                            "<text removed due to base-64 image data, displaying the text could cause the app to crash>";
                      }
                      setState(() {
                        result = txt;
                      });
                    },
                    child: Text(
                      "Submit",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                        backgroundColor: Theme.of(context).accentColor),
                    onPressed: () {
                      HtmlEditor.redo();
                    },
                    child: Text(
                      "Redo",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(result),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextButton(
                    style:
                        TextButton.styleFrom(backgroundColor: Colors.blueGrey),
                    onPressed: () {
                      HtmlEditor.disable();
                    },
                    child:
                        Text("Disable", style: TextStyle(color: Colors.white)),
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                        backgroundColor: Theme.of(context).accentColor),
                    onPressed: () async {
                      HtmlEditor.enable();
                    },
                    child: Text(
                      "Enable",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextButton(
                    style: TextButton.styleFrom(
                        backgroundColor: Theme.of(context).accentColor),
                    onPressed: () {
                      HtmlEditor.insertText("Google");
                    },
                    child: Text("Insert Text",
                        style: TextStyle(color: Colors.white)),
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                        backgroundColor: Theme.of(context).accentColor),
                    onPressed: () {
                      HtmlEditor.insertHtml(
                          "<p style=\"color: blue \">Google in blue</p>");
                    },
                    child: Text("Insert HTML",
                        style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextButton(
                    style: TextButton.styleFrom(
                        backgroundColor: Theme.of(context).accentColor),
                    onPressed: () async {
                      HtmlEditor.insertLink(
                          "Google linked", "https://google.com", true);
                    },
                    child: Text(
                      "Insert Link",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                        backgroundColor: Theme.of(context).accentColor),
                    onPressed: () {
                      HtmlEditor.insertNetworkImage(
                          "https://www.google.com/images/branding/googlelogo/2x/googlelogo_color_92x30dp.png",
                          filename: "Google network image");
                    },
                    child: Text(
                      "Insert network image",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
