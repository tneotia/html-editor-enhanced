# Flutter Html Editor - Enhanced
[![pub package](https://img.shields.io/pub/v/html_editor_enhanced.svg)](https://pub.dev/packages/html_editor_enhanced)

Flutter HTML Editor Enhanced is a text editor for Android and iOS to help write WYSIWYG HTML code with on the Summernote JavaScript wrapper.

<table>
  <tr>
    <td align="center">Video Example</td>
    <td align="center">Light Mode</td>
    <td align="center">Dark Mode</td>
  </tr>
  <tr>
    <td><img alt="GIF example" src="https://raw.githubusercontent.com/tneotia/html-editor-enhanced/master/screenshots/html_editor_enhanced.gif" width="250"/></td>
    <td><img alt="Light" src="https://raw.githubusercontent.com/tneotia/html-editor-enhanced/master/screenshots/html_editor_light.png" width="250"/></td>
    <td><img alt="Dark" src="https://raw.githubusercontent.com/tneotia/html-editor-enhanced/master/screenshots/html_editor_dark.png" width="250"/></td>
  </tr>
</table>

<table>
  <tr>
    <td align="center">Flutter Web</td>
  </tr>
  <tr>
    <td><img alt="Flutter Web" src="https://raw.githubusercontent.com/tneotia/html-editor-enhanced/master/screenshots/html_editor_web.png" width="800"/></td>
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
  
  - [Toolbar](#toolbar)
  
  - [Plugins](#plugins)

  - [Examples](#examples)

- [Notes](#notes)

- [License](#license)

- [Contribution Guide](#contribution-guide)
 
## In what ways is this package "enhanced"?

1. It has official support for Flutter Web, with nearly all mobile features supported. Keyboard shortcuts like Ctrl+B for bold work as well!

2. It uses a heavily optimized [WebView](https://github.com/pichillilorenzo/flutter_inappwebview) to deliver the best possible experience when using the editor

3. It doesn't use a local server to load the HTML code containing the editor. Instead, this package simply loads the HTML file, which improves performance and the editor's startup time.

4. It uses a `StatelessWidget`. You don't have to fiddle around with `GlobalKey`s to access methods, instead you can simply call `<controller name>.<method name>` anywhere you want.

5. It has support for many of Summernote's methods

6. It has support for many of Summernote's callbacks

7. It has support for some of Summernote's 3rd party plugins, found [here](https://github.com/summernote/awesome-summernote)

8. It exposes the `InAppWebViewController` so you can customize the WebView however you like - you can even load your own HTML code and inject your own JavaScript for your use cases.

9. It has support for dark mode

10. It has support for low-level customization, such as setting what buttons are shown on the toolbar

More is on the way! File a feature request or contribute to the project if you'd like to see other features added.

## Setup

Add `html_editor_enhanced: ^1.5.0` as dependency to your pubspec.yaml

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
<uses-permission android:name="android.permission.INTERNET"/>
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

HtmlEditorController controller = HtmlEditorController();

@override
void dispose() {
    //it is highly recommended to dispose on mobile to properly close the stream it uses to get text
    controller.dispose();
    super.dispose();
}

@override Widget build(BuildContext context) {
    return HtmlEditor(
            controller: controller, //required
            hint: "Your text here...",
            //value: "text content initial, if any",
            height: 400,
    );
}
```

When you want to get text from the editor:
```dart
final txt = await controller.getText();
```

## API Reference

For the full API reference, see [here](https://pub.dev/documentation/html_editor_enhanced/latest/).

For a full example, see [here](https://github.com/tneotia/html-editor-enhanced/tree/master/example).

Below, you will find brief descriptions of the parameters the`HtmlEditor` widget accepts and some code snippets to help you use this package.

### Parameters

Parameter | Type | Default | Description
------------ | ------------- | ------------- | -------------
**controller** | `HtmlEditorController` | empty | Required param. Create a controller instance and pass it to the widget. This ensures that any methods called work only on their `HtmlEditor` instance, allowing you to use multiple HTML widgets on one page.
**initialText** | `String` | empty | Initial text content for text editor
**height** | `double` | 380 | Height of text editor (does not set the height in HTML yet, only the height of the WebView widget)
**decoration** | `BoxDecoration` |  | `BoxDecoration` that surrounds the widget
**showBottomToolbar** | `bool` | true | Show or hide bottom toolbar
**hint** | `String` | empty | Placeholder hint text
**callbacks** | `Callbacks` | empty | Customize the callbacks for various events
**toolbar** | `List<Toolbar>` | See the widget's constructor | Customize what buttons are shown on the toolbar, and in which order. See [below](#toolbar) for more details.
**plugins** | `List<Plugins>` | empty | Customize what plugins are activated. See [below](#plugins) for more details.
**darkMode** | `bool` | `null` | Sets the status of dark mode - `false`: always light, `null`: follow system, `true`: always dark 

### Methods

Access these methods like this: `<controller name>.<method name>`

Method | Argument(s) | Returned Value(s) | Description
------------ | ------------- | ------------- | -------------
**dispose()** | N/A | N/A | Disposes the stream used to get the editor's contents on mobile. Do *not* use this method in Flutter Web.
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
**reloadWeb()** | N/A | N/A | Reloads the webpage in Flutter Web. This is mainly provided to refresh the text editor theme when the theme is changed. Do *not* use this method in Flutter Mobile.

### Callbacks

Every callback is defined as a `Function(<parameters in some cases>)`. See the [documentation](https://pub.dev/documentation/html_editor_enhanced/latest/) for more specific details on each callback.
 
Callback | Parameter(s) | Description
------------ | ------------- | -------------
**onChange** | `String` | Called when the content of the editor changes, passes the current HTML in the editor
**onEnter** | N/A | Called when enter/return is pressed
**onFocus** | N/A | Called when the rich text field gains focus
**onBlur** | N/A | Called when the rich text field or the codeview loses focus
**onBlurCodeview** | N/A | Called when the codeview either gains or loses focus
**onInit** | N/A | Called when the rich text field is initialized and JavaScript methods can be called
**onKeyDown** | `int` | Called when a key is downed, passes the keycode of the downed key
**onKeyUp** | `int` | Called when a key is released, passes the keycode of the released key
**onPaste** | N/A | Called when content is pasted into the editor

### Getters

Currently, the package has one getter: `<controller name>.editorController`. This returns the `InAppWebViewController`, which manages the webview that displays the editor.

This is extremely powerful, as it allows you to create your own custom methods and implementations directly in your app. See [`flutter_inappwebview`](https://github.com/pichillilorenzo/flutter_inappwebview) for documentation on the controller.

This getter *should not* be used in Flutter Web. If you are making a cross platform implementation, please use `kIsWeb` to check the current platform in your code.

### Toolbar

This API allows you to customize Summernote's toolbar in a nice, readable format (you don't have to mess around with strings!).

By default, the toolbar will be set to:

```text
toolbar: [
  ['style', ['style']],
  ['font', ['bold', 'underline', 'clear']],
  ['color', ['color']],
  ['para', ['ul', 'ol', 'paragraph']],
  ['insert', ['link', 'picture', 'video', 'table']],
  ['view', ['fullscreen', 'codeview', 'help']],
],
```

This is pretty close to Summernote's [default options](https://summernote.org/deep-dive/#custom-toolbar-popover). Setting `toolbar` to null or empty will initialize the editor with these options.

Well, what if you want to customize it? Don't worry, it's a nice and neat API:

```dart
HtmlEditorController controller = HtmlEditorController();
Widget htmlEditor = HtmlEditor(
  controller: controller, //required
  //other options
  toolbar: [
    Style(),
    Font(buttons: [FontButtons.bold, FontButtons.underline, FontButtons.italic])
  ]
);
```

In the above example, the editor will only be initialized with the 'style', 'bold', 'underline', and 'italic' buttons.

If you leave the `Toolbar` constructor blank (like `Style()` above), then the package interprets that you want the default buttons for `Style` to be visible.

You can specify a list of buttons that are visible for each `Toolbar` constructor. Each constructor accepts a different type of enum in its button list, so you'll always put the right buttons in the right places.

If you don't want to show an entire group of buttons, simply don't include their constructor in the `Toolbar` list!

Note: Setting `buttons: []` will also be interpreted as wanting the default buttons for the constructor rather than not showing the group of buttons.

### Plugins

This API allows you to add certain Summernote plugins from the [Summernote Awesome library](https://github.com/summernote/awesome-summernote).

Currently the following plugins are supported:

1. [Summernote Emoji from Ajax](https://github.com/tylerecouture/summernote-ext-emoji-ajax/)
Adds a button to the toolbar to allow the user to insert emojis. These are loaded via Ajax.

2. [Summernote Add Text Tags](https://github.com/tylerecouture/summernote-add-text-tags)
Adds a button to the toolbar to support tags like var, code, samp, and more.

3. [Summernote Classes](https://github.com/DiemenDesign/summernote-classes)
Adds a hotbar at the bottom of the editor to quickly and easily add common tags for the specific HTML node. This should only be used by advanced users, ideally.

4. [Summernote Case Converter](https://github.com/piranga8/summernote-case-converter)
Adds a button to the toolbar to convert the selected text to all lowercase, all uppercase, sentence case, or title case.

5. [Summernote List Styles](https://github.com/tylerecouture/summernote-list-styles)
Adds a button to the toolbar to customize the ul and ol list style.

6. [Summernote RTL](https://github.com/virtser/summernote-rtl-plugin)
Adds two buttons to the toolbar that switch the currently selected text between LTR and RTL format.

7. [Summernote At Mention](https://github.com/team-loxo/summernote-at-mention)
Shows a dropdown of available mentions when the '@' character is typed into the editor. The implementation requires that you pass a list of available mentions, and you can also provide a function to call when a mention is inserted into the editor.

This list is not final, more will be added. If there's a specific plugin you'd like to see support for, please file a feature request!

By default, no plugins will be activated. What if you want to activate some? Don't worry, it's a nice and neat API:

```dart
HtmlEditorController controller = HtmlEditorController();
Widget htmlEditor = HtmlEditor(
  controller: controller, //required
  //other options
  plugins: [
    SummernoteEmoji(),
    SummernoteClasses()
  ]
);
```

In the above example, only those two plugins will be activated in the editor. Order matters here - whatever order you define the plugins is the order their buttons will be displayed in the toolbar.

All plugin buttons will be displayed in one section in the toolbar. Overriding the toolbar using the `toolbar` parameter does not affect how the plugin buttons are displayed. 

Please see the `plugins.dart` file for more specific details on each plugin, including some important notes to consider when deciding whether or not to use them in your implementation.

### Examples

See the [example app](https://github.com/tneotia/html-editor-enhanced/blob/master/example/lib/main.dart) to see how the majority of methods & callbacks can be used. You can also play around with the parameters to see how they function.

This section will be updated later with more specialized and specific examples as this library grows and more features are implemented.

## Notes

Due to this package depending on a webview for rendering the HTML editor, there will be some general weirdness in how the editor behaves. Unfortunately, these are not things I can fix, they are inherent problems with how webviews function on Flutter.

If you do find any issues, please report them in the Issues tab and I will see if a fix is possible, but if I close the issue it is likely due to the above fact.

1. When switching between dark and light mode, a reload is required for the HTML editor to switch to the correct color scheme. You can implement this programmatically in Flutter Mobile: `<controller name>.editorController.reload()`, or in Flutter Web: `<controller name>.reloadWeb()`. This will reset the editor! You can save the current text, reload, and then set the text if you'd like to maintain the state.

2. If you are making a cross platform implementation and are using either the `controller` getter or the `reloadWeb()` method, use `kIsWeb` in your app to ensure you are calling these in the correct platform.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contribution Guide

> Coming soon!
>
> Meanwhile, PRs are always welcome