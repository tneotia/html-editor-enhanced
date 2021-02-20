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

Additional setup is required to allow the user to pick images via `<input type="file">`, add the following to your app's AndroidManifest.xml inside the `<application>` tag:

```xml
<provider
   android:name="com.pichillilorenzo.flutter_inappwebview.InAppWebViewFileProvider"
   android:authorities="${applicationId}.flutter_inappwebview.fileprovider"
   android:exported="false"
   android:grantUriPermissions="true">
   <meta-data
       android:name="android.support.FILE_PROVIDER_PATHS"
       android:resource="@xml/provider_paths" />
</provider>
```

## Usage

```dart
import 'package:html_editor/html_editor.dart';
// other code here
@override Widget build(BuildContext context) {
    return HtmlEditor(
            hint: "Your text here...",
            //value: "text content initial, if any",
            height: 400,
    );
}
```

When you want to get text from the editor:
```dart
final txt = await HtmlEditor.getText();
```

### In what ways is this package "enhanced"?

1. It uses a heavily optimized [WebView](https://github.com/pichillilorenzo/flutter_inappwebview) to deliver the best possible experience when using the editor

2. It doesn't use a local server to load the HTML code containing the editor. Instead, this package simply loads the HTML file, which improves performance and the editor's startup time.

3. It uses a `StatelessWidget`. You don't have to fiddle around with `GlobalKey`s to access methods, instead you can simply call `HtmlEditor.<method name>` anywhere you want.

4. It has support for many of Summernote's methods

5. It has support for many of Summernote's callbacks

6. It exposes the `InAppWebViewController` so you can customize the WebView however you like - you can even load your own HTML code and inject your own JavaScript for your use cases.

More is on the way! File a feature request or contribute to the project if you'd like to see other features added.

### Parameters

Parameter | Type | Default | Description
------------ | ------------- | ------------- | -------------
**value** | String | empty | initial text content for text editor
**height** | double | 380 | height of text editor
**decoration** | BoxDecoration |  | Decoration editor
**useBottomSheet** | bool | true | if true, open a bottom sheet (Android intent style) to pick an image, otherwise use a dialog
**widthImage** | String | 100% | width of image picker
**showBottomToolbar** | bool | true | show or hide bottom toolbar
**hint** | String | empty | Placeholder hint text
**callbacks** | Callbacks | empty | Customize the callbacks for various events

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
