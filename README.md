# Flutter Html Editor

Flutter HTML Editor is a text editor for android and iOS to help write WYSIWYG HTML code based on the Summernote javascript wrapper. with this library you can insert images into the text editor

![demo example](https://github.com/xrb21/flutter-html-editor/blob/master/screenshoot/flutter_html_editor.gif)  ![demo android](https://github.com/xrb21/flutter-html-editor/blob/master/screenshoot/sc.jpeg)   ![demo ios](https://github.com/xrb21/flutter-html-editor/blob/master/screenshoot/sc_iphone.png)


## Setup

add ```html_editor: ^1.0.0``` as deppendecy to pubspec.yaml

### iOS

Add the following keys to your Info.plist file, located in <project root>/ios/Runner/Info.plist:

- Opt-in to the embedded views preview :
    ```
        <key>io.flutter.embedded_views_preview</key>
        <true/>
    ```
- Add following code:
    ```
        <dict>
            <key>NSAllowsArbitraryLoads</key>
             <true/>
        </dict>
    ```
- NSPhotoLibraryUsageDescription - describe why your app needs permission for the photo library:
    ```
        <key>NSPhotoLibraryUsageDescription</key>
        <string>Used to demonstrate image picker plugin</string>
    ```
- NSCameraUsageDescription - describe why your app needs access to the camera:
    ```
        <key>NSCameraUsageDescription</key>
        <string>Used to demonstrate image picker plugin</string>
    ```
- NSMicrophoneUsageDescription - describe why your app needs access to the microphone:
    ```
        <key>NSMicrophoneUsageDescription</key>
        <string>Used to capture audio for image picker plugin</string>
    ```


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

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

`#MajalengkaExoticSundaland`



