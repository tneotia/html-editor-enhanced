# Flutter Html Editor - Enhanced

Flutter HTML Editor is a text editor for Android and iOS to help write WYSIWYG HTML code with on the Summernote JavaScript wrapper.

![demo example](https://github.com/xrb21/flutter-html-editor/blob/master/screenshoot/flutter_html_editor.gif)  ![demo android](https://github.com/xrb21/flutter-html-editor/blob/master/screenshoot/sc.jpeg)   ![demo ios](https://github.com/xrb21/flutter-html-editor/blob/master/screenshoot/sc_iphone.png)

## Setup

Add `html_editor_enhanced: ^1.1.1` as dependency to your pubspec.yaml

<details><summary>Follow the setup instructions for the image_picker plugin</summary>

### iOS

Add the following keys to your _Info.plist_ file, located in `<project root>/ios/Runner/Info.plist`:

* `NSPhotoLibraryUsageDescription` - describe why your app needs permission for the photo library. This is called _Privacy - Photo Library Usage Description_ in the visual editor.
* `NSCameraUsageDescription` - describe why your app needs access to the camera. This is called _Privacy - Camera Usage Description_ in the visual editor.
* `NSMicrophoneUsageDescription` - describe why your app needs access to the microphone, if you intend to record videos. This is called _Privacy - Microphone Usage Description_ in the visual editor.

### Android

#### API < 29
No configuration required - the plugin should work out of the box.

#### API 29+

Add `android:requestLegacyExternalStorage="true"` as an attribute to the `<application>` tag in AndroidManifest.xml. The [attribute](https://developer.android.com/training/data-storage/compatibility) is `false` by default on apps targeting Android Q. 

</details>

### Usage

```dart
import 'package:html_editor/html_editor.dart';
// other code here
@override Widget build(BuildContext context) {
    return HtmlEditor(
            hint: "Your text here...",
            //value: "text content initial, if any",
            key: keyEditor,
            height: 400,
    );
}
```

When you want to get text from the editor:
```
    final txt = await HtmlEditor.getText();
```


### Available option parameters

Parameter | Type | Default | Description
------------ | ------------- | ------------- | -------------
**value** | String | empty | initial text content for text editor
**height** | double | 380 | height of text editor
**decoration** | BoxDecoration |  | Decoration editor
**useBottomSheet** | bool | true | if true, open a bottom sheet (OneUI style) to pick an image, otherwise use a dialog
**widthImage** | String | 100% | width of image picker
**showBottomToolbar** | bool | true | show or hide bottom toolbar
**hint** | String | empty | Placeholder hint text


## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
