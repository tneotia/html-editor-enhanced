# Flutter Html Editor

Flutter HTML Editor is a text editor to help write WYSIWYG HTML code based on the Summernote javascript wrapper. with this library you can insert images into the text editor

![demo example](https://github.com/xrb21/flutter-html-editor/blob/master/screenshoot/flutter_html_editor.gif)  ![demo example](https://github.com/xrb21/flutter-html-editor/blob/master/screenshoot/sc.jpeg)


## Setup

add ```html_editor``` as deppendecy to pubspec.yaml

### iOS

Opt-in to the embedded views preview by adding a boolean property to the app's ```Info.plist``` file with the key ```io.flutter.embedded_views_preview``` and the value ```YES```.

### Usage

1. import flutter html editor
```
    import 'package:html_editor/html_editor.dart';
```

2. Create Global key from HTML Editor State
```
    GlobalKey<HtmlEditorState> keyEditor = GlobalKey();
```

3. Add HTML Editor to widget
```
    HtmlEditor(
        hint: "Your text here...",
        //value: "text content initial, if any",
        key: keyEditor,
        height: 400,
    ),
```

4. Get text from Html Editor
```
    final txt = await keyEditor.currentState.getText();
```


### Avalaible option parameters

Parameter | Type | Default | Description
------------ | ------------- | ------------- | -------------
**key** | GlobalKey<HtmlEditorState> | **required** | for get method & reset
**value** | String | empty | iniate text content for text editor
**height** | double | 380 | height of text editor
**decoration** | BoxDecoration |  | Decoration editor
**useBottomSheet** | bool | true | if true Pickup image user bottomsheet or dialog if else
**widthImage** | String | 100% | width of image picker
**showBottomToolbar** | bool | true | show hide bottom toolbar
**hint** | String | empty | Placeholder hint text


## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details



