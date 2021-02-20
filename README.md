# Flutter Html Editor - Enhanced
[![pub package](https://img.shields.io/pub/v/html_editor_enhanced.svg)](https://pub.dev/packages/html_editor_enhanced)

Flutter HTML Editor Enhanced is a text editor for Android and iOS to help write WYSIWYG HTML code with on the Summernote JavaScript wrapper.

<table>
  <tr>
    <td align="center">Video Example</td>
  </tr>
  <tr>
    <td><img alt="GIF example" src="https://github.com/tneotia/html-editor-enhanced/blob/master/screenshots/html_editor_enhanced.gif" width="250"/></td>
  </tr>
</table>

## Table of Contents:

- ["Enhanced"? In what ways?](#in-what-ways-is-this-package-enhanced)

- [Setup](#setup)

- [Usage](#basic-usage)

- [API Reference](#api-reference)

  - [Parameters Table](#parameters)

  - [Methods Table](#methods)

  - [Callbacks Table](#callbacks)
  
  - [Getters](#getters)

  - [Examples](#examples)

- [Notes](#notes)

- [License](#license)

- [Contribution Guide](#contribution-guide)
 
## In what ways is this package "enhanced"?

1. It uses a heavily optimized [WebView](https://github.com/pichillilorenzo/flutter_inappwebview) to deliver the best possible experience when using the editor

2. It doesn't use a local server to load the HTML code containing the editor. Instead, this package simply loads the HTML file, which improves performance and the editor's startup time.

3. It uses a `StatelessWidget`. You don't have to fiddle around with `GlobalKey`s to access methods, instead you can simply call `HtmlEditor.<method name>` anywhere you want.

4. It has support for many of Summernote's methods

5. It has support for many of Summernote's callbacks

6. It exposes the `InAppWebViewController` so you can customize the WebView however you like - you can even load your own HTML code and inject your own JavaScript for your use cases.

More is on the way! File a feature request or contribute to the project if you'd like to see other features added.

## Setup

Add `html_editor_enhanced: ^1.2.0` as dependency to your pubspec.yaml

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

Additional setup is required to allow the user to pick images via `<input type="file">`:

<details><summary>Instructions</summary>

Add the following to your app's AndroidManifest.xml inside the `<application>` tag:

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

And add the following above the `<application>` tag:

```xml
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
```

In Dart, you'll need to request these permissions. You can use [`permission_handler`](https://pub.dev/packages/permission_handler) like this:

```dart
//Android
await Permission.storage.request();
//iOS
await Permission.photos.request();
```

If you'd like the user to be able to insert images via the camera, you need to request for those permissions. AndroidManifest:

```xml
<uses-permission android:name="android.permission.CAMERA"/>
```

Dart:

```dart
await Permission.camera.request();
```

You must request the permissions in Dart before the user accesses the file upload dialog. I recommend requesting the permissions in `initState()` or something similar.

IMPORTANT: When using `permission_handler` on iOS, you must modify the Podfile, otherwise you will not be able to upload a build to App Store Connect. Add the following at the very bottom, right underneath `flutter_additional_ios_build_settings(target)`:

```text
target.build_configurations.each do |config|
  config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] ||= [
      '$(inherited)',
      ## use a hashtag symbol on the permissions you want to include in your app. Make sure they are defined in Info.plist as well! 
      ## dart: PermissionGroup.calendar
      'PERMISSION_EVENTS=0',

      ## dart: PermissionGroup.reminders
      'PERMISSION_REMINDERS=0',

      ## dart: PermissionGroup.contacts
      'PERMISSION_CONTACTS=0',

      ## dart: PermissionGroup.camera
      'PERMISSION_CAMERA=0',

      ## dart: PermissionGroup.microphone
      'PERMISSION_MICROPHONE=0',

      ## dart: PermissionGroup.speech
      'PERMISSION_SPEECH_RECOGNIZER=0',

      ## dart: PermissionGroup.photos
      # 'PERMISSION_PHOTOS=0',

      ## dart: [PermissionGroup.location, PermissionGroup.locationAlways, PermissionGroup.locationWhenInUse]
      'PERMISSION_LOCATION=0',

      ## dart: PermissionGroup.notification
      'PERMISSION_NOTIFICATIONS=0',

      ## dart: PermissionGroup.mediaLibrary
      'PERMISSION_MEDIA_LIBRARY=0',

      ## dart: PermissionGroup.sensors
      'PERMISSION_SENSORS=0'
    ]
 end
```

If you decide to allow images directly from the camera, you will need to comment `'PERMISSION_CAMERA=0',` as well.

</details>

## Basic Usage

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

## API Reference

For the full API reference, see [here](https://pub.dev/documentation/html_editor_enhanced/latest/).

For a full example, see [here](https://github.com/tneotia/html-editor-enhanced/tree/master/example).

Below, you will find brief descriptions of the parameters the`HtmlEditor` widget accepts and some code snippets to help you use this package.

### Parameters

Parameter | Type | Default | Description
------------ | ------------- | ------------- | -------------
**initialText** | `String` | empty | Initial text content for text editor
**height** | `double` | 380 | Height of text editor (does not set the height in HTML yet, only the height of the WebView widget)
**decoration** | `BoxDecoration` |  | `BoxDecoration` that surrounds the widget
**useBottomSheet** | `bool` | true | If true, open a bottom sheet (Android intent style) to pick an image, otherwise use a dialog
**imageWidth** | `double` | 100 | Width of image once inserted. Must be between 0 and 100.
**showBottomToolbar** | `bool` | true | Show or hide bottom toolbar
**hint** | `String` | empty | Placeholder hint text
**callbacks** | `Callbacks` | empty | Customize the callbacks for various events

### Methods

Access these methods like this: `HtmlEditor.<method name>`

Method | Argument(s) | Returned Value(s) | Description
------------ | ------------- | ------------- | -------------
**getText()** | N/A | `Future<String>` | Returns the current HTML in the editor
**setText()** | `String` | N/A | Sets the current text in the HTML to the input HTML string
**setFullScreen()** | N/A | N/A | Sets the editor to take up the entire size of the webview
**setFocus()** | N/A | N/A | If the pointer is in the webview, the focus will be set to the editor box
**clear()** | N/A | N/A | Resets the HTML editor to its default state
**setHint()** | `String` | N/A | Sets the current hint text of the editor
**toggleCodeview()** | N/A | N/A | Toggles between the code view and the rich text view
**disable()** | N/A | N/A | Disables the editor (a gray mask is applied and all touches are absorbed)
**enable()** | N/A | N/A | Enables the editor
**undo()** | N/A | N/A | Undoes the last command in the editor
**redo()** | N/A | N/A | Redoes the last command in the editor
**insertText()** | `String` | N/A | Inserts the provided text into the editor at the current cursor position. Do *not* use this method for HTML strings.
**insertHtml()** | `String` | N/A | Inserts the provided HTML string into the editor at the current cursor position. Do *not* use this method for plaintext strings.
**insertNetworkImage()** | `String` url, `String` filename (optional) | N/A | Inserts an image using the provided url and optional filename into the editor at the current cursor position. The image must be accessible via a URL.
**insertLink()** | `String` text, `String` url, `bool` isNewWindow | N/A | Inserts a hyperlink using the provided text and url into the editor at the current cursor position. `isNewWindow` defines whether a new browser window is launched if the link is tapped.

### Callbacks

Every callback is defined as a `Function(<parameters in some cases>)`. See the [documentation](https://pub.dev/documentation/html_editor_enhanced/latest/) for more specific details on each callback.
 
Callback | Parameter(s) | Description
------------ | ------------- | -------------
**onChange** | `String` | Called when the content of the editor changes, passes the current HTML in the editor
**onEnter** | N/A | Called when enter/return is pressed
**onFocus** | N/A | Called when the rich text field gains focus
**onBlur** | N/A | Called when the rich text field or the codeview loses focus
**onBlurCodeview** | N/A | Called when the codeview either gains or loses focus
**onKeyDown** | `int` | Called when a key is downed, passes the keycode of the downed key
**onKeyUp** | `int` | Called when a key is released, passes the keycode of the released key
**onPaste** | N/A | Called when content is pasted into the editor

### Getters

Currently, the package has one getter: `HtmlEditor.controller`. This returns the `InAppWebViewController`, which manages the webview that displays the editor.

This is extremely powerful, as it allows you to create your own custom methods and implementations directly in your app. See [`flutter_inappwebview`](https://github.com/pichillilorenzo/flutter_inappwebview) for documentation on the controller.

### Examples

See the [example app](https://github.com/tneotia/html-editor-enhanced/blob/master/example/lib/main.dart) to see how the majority of methods & callbacks can be used. You can also play around with the parameters to see how they function.

This section will be updated later with more specialized and specific examples as this library grows and more features are implemented.

## Notes

Due to this package depending on a webview for rendering the HTML editor, there will be some general weirdness in how the editor behaves. Unfortunately, these are not things I can fix, they are inherent problems with how webviews function on Flutter.

If you do find any issues, please report them in the Issues tab and I will see if a fix is possible, but if I close the issue it is likely due to the above fact.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contribution Guide

> Coming soon!
>
> Meanwhile, PRs are always welcome