# Flutter Html Editor - Enhanced
[![pub package](https://img.shields.io/pub/v/html_editor_enhanced.svg)](https://pub.dev/packages/html_editor_enhanced)

Flutter HTML Editor Enhanced is a text editor for Android, iOS, and Web to help write WYSIWYG HTML code with the Summernote JavaScript wrapper.

Note that the API shown in this README.md file shows only a part of the documentation and, also, conforms to the GitHub master branch only! So, here you could have methods, options, and events that aren't published/released yet! If you need a specific version, please change the GitHub branch of this repository to your version or use the online [API Reference](https://pub.dev/documentation/html_editor_enhanced/latest/) (recommended).

<table>
  <tr>
    <td align="center">Video Example</td>
    <td align="center">Light Mode and <pre>ToolbarType.nativeGrid</pre></td>
    <td align="center">Dark Mode and <pre>ToolbarPosition.belowEditor</pre></td>
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

<br/>

## Table of Contents:

- ["Enhanced"? In what ways?](#in-what-ways-is-this-package-enhanced)

- [Setup](#setup)

- [Usage](#basic-usage)

- [API Reference](#api-reference)

  - [Parameters Table](#parameters---htmleditor)

  - [Methods Table](#methods)

  - [Callbacks Table](#callbacks)
  
  - [Getters](#getters)
  
  - [Toolbar](#toolbar)
  
  - [Plugins](#plugins)
  
  - [`HtmlEditorOptions` Parameters](#htmleditoroptions-parameters)
    
    - [`autoAdjustHeight`](#autoadjustheight)
  
    - [`adjustHeightForKeyboard`](#adjustheightforkeyboard)
  
    - [`filePath`](#filepath)
  
    - [`shouldEnsureVisible`](#shouldensurevisible)
    
    - [`webInitialScripts`](#webinitialscripts)
    
  - [`HtmlToolbarOptions` Parameters](#htmltoolbaroptions-parameters)
  
    - [`customToolbarButtons` and `customToolbarButtonsInsertionIndices`](#customtoolbarbuttons-and-customtoolbarbuttonsinsertionindices)
    
    - [`linkInsertInterceptor`, `mediaLinkInsertInterceptor`, `otherFileLinkInsert`, `mediaUploadInterceptor`, and `onOtherFileUpload`](#linkinsertinterceptor-medialinkinsertinterceptor-otherfilelinkinsert-mediauploadinterceptor-and-onotherfileupload)
    
    - [`onButtonPressed` and `onDropdownChanged`](#onbuttonpressed-and-ondropdownchanged)
    
    - [`toolbarPosition: ToolbarPosition.custom`](#custom-toolbar-position-using-toolbarpositioncustom)
    
  - [`HtmlEditorController` Parameters](#htmleditorcontroller-parameters)
  
    - [`processInputHtml`, `processOutputHtml`, and `processNewLineAsBr`](#processinputhtml-processoutputhtml-and-processnewlineasbr)

- [Examples](#examples)

- [Notes](#notes)

- [FAQ](#faq)

- [License](#license)

- [Contribution Guide](#contribution-guide)
 
## In what ways is this package "enhanced"?

1. It has official support for Flutter Web, with nearly all mobile features supported. Keyboard shortcuts like Ctrl+B for bold work as well!

2. It has fully native Flutter-based widget controls

3. It uses a heavily optimized [WebView](https://github.com/pichillilorenzo/flutter_inappwebview) to deliver the best possible experience when using the editor

4. It doesn't use a local server to load the HTML code containing the editor. Instead, this package simply loads the HTML file, which improves performance and the editor's startup time.

5. It uses a controller-based API. You don't have to fiddle around with `GlobalKey`s to access methods, instead you can simply call `<controller name>.<method name>` anywhere you want.

6. It has support for many of Summernote's methods

7. It has support for all of Summernote's callbacks

8. It exposes the `InAppWebViewController` so you can customize the WebView however you like - you can even load your own HTML code and inject your own JavaScript for your use cases.

9. It has support for dark mode

10. It has support for extremely granular toolbar customization

More is on the way! File a feature request or contribute to the project if you'd like to see other features added.

## Setup

Add `html_editor_enhanced: ^2.5.0` as dependency to your pubspec.yaml.

Make sure to declare internet support inside `AndroidManifest.xml`: `<uses-permission android:name="android.permission.INTERNET"/>`

Additional setup is required on iOS to allow the user to pick files from storage. See [here](https://github.com/miguelpruivo/flutter_file_picker/wiki/Setup#--ios) for more details. 

For images, the package uses `FileType.image`, for video `FileType.video`, for audio `FileType.audio`, and for any other file `FileType.any`. You can just complete setup for the specific buttons you plan to enable in the editor.

#### v2.0.0 Migration Guide:

[Migration Guide](https://github.com/tneotia/html-editor-enhanced/wiki/v2.0.0-Migration-Guide)

## Basic Usage

```dart
import 'package:html_editor/html_editor.dart';

HtmlEditorController controller = HtmlEditorController();

@override Widget build(BuildContext context) {
    return HtmlEditor(
        controller: controller, //required
        htmlEditorOptions: HtmlEditorOptions(
          hint: "Your text here...",
          //initalText: "text content initial, if any",
        ),   
        otherOptions: OtherOptions(
          height: 400,
        ),
    );
}
```

### Important note for Web:

At the moment, there is quite a bit of flickering and repainting when having many UI elements draw over `IframeElement`s. See https://github.com/flutter/flutter/issues/71888 for more details.

The current workaround is to build and/or run your Web app with `flutter run --web-renderer html` and `flutter build web --web-renderer html`.

Follow https://github.com/flutter/flutter/issues/80524 for updates on a potential fix, in the meantime the above solution should resolve the majority of the flickering issues.

## API Reference

For the full API reference, see [here](https://pub.dev/documentation/html_editor_enhanced/latest/).

For a full example, see [here](https://github.com/tneotia/html-editor-enhanced/tree/master/example).

Below, you will find brief descriptions of the parameters the `HtmlEditor` widget accepts and some code snippets to help you use this package.

### Parameters - `HtmlEditor`

Parameter | Type | Default | Description
------------ | ------------- | ------------- | -------------
**controller** | `HtmlEditorController` | empty | Required param. Create a controller instance and pass it to the widget. This ensures that any methods called work only on their `HtmlEditor` instance, allowing you to use multiple HTML widgets on one page.
**callbacks** | `Callbacks` | empty | Customize the callbacks for various events
**options** | `HtmlEditorOptions` | `HtmlEditorOptions()` | Class to set various options. See [below](#parameters---htmleditoroptions) for more details.
**plugins** | `List<Plugins>` | empty | Customize what plugins are activated. See [below](#plugins) for more details.
**toolbar** | `List<Toolbar>` | See the widget's constructor | Customize what buttons are shown on the toolbar, and in which order. See [below](#toolbar) for more details.

### Parameters - `HtmlEditorController`

Parameter | Type | Default | Description
------------ | ------------- | ------------- | -------------
**processInputHtml** | `bool` | `true` | Determines whether processing occurs on any input HTML (e.g. escape quotes, apostrophes, and remove `/n`s)
**processNewLineAsBr** | `bool` | `false` | Determines whether a new line (`\n`) becomes a `<br/>` in any *input* HTML
**processOutputHtml** | `bool` | `true` | Determines whether processing occurs on any output HTML (e.g. `<p><br/><p>` becomes `""`)

### Parameters - `HtmlEditorOptions`

Parameter | Type | Default | Description
------------ | ------------- | ------------- | -------------
**autoAdjustHeight** | `bool` | `true` | Automatically adjust the height of the text editor by analyzing the HTML height once the editor is loaded. Recommended value: `true`.  See [below](#autoadjustheight) for more details.
**adjustHeightForKeyboard** | `bool` | `true` | Adjust the height of the editor if the keyboard is active and it overlaps the editor to prevent the overlap. Recommended value: `true`, only works on mobile.  See [below](#adjustheightforkeyboard) for more details.
**characterLimit** | `int` | `null` | Sets the character limit for the editor. When reaching the limit the user will not be allowed to type anymore.
**customOptions** | `String` | `null` | Provide custom options for Summernote initialization using the Summernote syntax (see [here](https://summernote.org/deep-dive/#initialization-options)
**darkMode** | `bool` | `null` | Sets the status of dark mode - `false`: always light, `null`: follow system, `true`: always dark
**filePath** | `String` | `null` | Allows you to specify your own HTML to be loaded into the webview. You can create a custom page with Summernote, or theoretically load any other editor/HTML.
**hint** | `String` | empty | Placeholder hint text
**initialText** | `String` | empty | Initial text content for text editor
**inputType** | `HtmlInputType` | `HtmlInputType.text` | Allows you to set how the virtual keyboard displays for the editor on mobile devices
**mobileContextMenu** | `ContextMenu` | `null` | Customize the context menu when a user selects text in the editor. See docs for `ContextMenu` [here](https://inappwebview.dev/docs/context-menu/basic-usage/)
**mobileLongPressDuration** | `Duration` | `Duration(milliseconds: 500)` | Set the duration until a long-press is recognized
**mobileInitialScripts** | `UnmodifiableListView<UserScript>` | `null` | Easily inject scripts to perform actions like changing the background color of the editor. See docs for `UserScript` [here](https://inappwebview.dev/docs/javascript/user-scripts/)
**webInitialScripts** | `UnmodifiableListView<WebScript>` | `null` | Easily inject scripts to perform actions like changing the background color of the editor. See [below](#webinitialscripts) for more details.
**shouldEnsureVisible** | `bool` | `false` | Scroll the parent `Scrollable` to the top of the editor widget when the webview is focused. Do *not* use this parameter if `HtmlEditor` is not inside a `Scrollable`. See [below](#shouldensurevisible) for more details.
**spellCheck** | `bool` | `false` | Specify whether or not to use spellcheck in the editor and underline wrong spellings.

### Parameters - `HtmlToolbarOptions`

#### Toolbar Options

Parameter | Type | Default | Description
------------ | ------------- | ------------- | -------------
**audioExtensions** | `List<String>` | `null` | Allowed extensions when inserting audio files
**customToolbarButtons** | `List<Widget>` | empty | Add custom buttons to the toolbar
**customToolbarInsertionIndices** | `List<int>` | empty | Allows you to set where each custom toolbar button should be inserted into the toolbar widget list
**defaultToolbarButtons** | `List<Toolbar>` | (all constructors active) | Allows you to hide/show certain buttons or certain groups of buttons
**otherFileExtensions** | `List<String>` | `null` | Allowed extensions when inserting files other than image/audio/video
**imageExtensions** | `List<String>` | `null` | Allowed extensions when inserting images
**initiallyExpanded** | `bool` | `false` | Sets whether the toolbar is initially expanded or not when using `ToolbarType.nativeExpandable`
**linkInsertInterceptor** | `FutureOr<bool> Function(String, String, bool)` | `null` | Intercept any links inserted into the editor. The function passes the display text, the URL, and whether it opens a new tab.
**mediaLinkInsertInterceptor** | `FutureOr<bool> Function(String, InsertFileType)` | `null` | Intercept any media links inserted into the editor. The function passes the URL and `InsertFileType` which indicates which file type was inserted
**mediaUploadInterceptor** | `FutureOr<bool> Function(PlatformFile, InsertFileType)` | `null` | Intercept any media files inserted into the editor. The function passes `PlatformFile` which holds all relevant file data, and `InsertFileType` which indicates which file type was inserted.
**onButtonPressed** | `FutureOr<bool> Function(ButtonType, bool?, void Function()?)` | `null` | Intercept any button presses. The function passes the enum for the pressed button, the current selected status of the button (if applicable) and a function to update the status (if applicable).
**onDropdownChanged** | `FutureOr<bool> Function(DropdownType, dynamic, void Function(dynamic)?)` | `null` | Intercept any dropdown changes. The function passes the enum for the changed dropdown, the changed value, and a function to update the changed value (if applicable).
**onOtherFileLinkInsert** | `Function(String)` | `null` | Intercept file link inserts other than image/audio/video. This handler is required when using the other file button, as the package has no built-in handlers
**onOtherFileUpload** | `Function(PlatformFile)` | `null` | Intercept file uploads other than image/audio/video. This handler is required when using the other file button, as the package has no built-in handlers
**otherFileExtensions** | `List<String>` | `null` | Allowed extensions when inserting files other than image/audio/video
**toolbarType** | `ToolbarType` | `ToolbarType.nativeScrollable` | Customize how the toolbar is displayed (gridview, scrollable, or expandable)
**toolbarPosition** | `ToolbarPosition` | `ToolbarPosition.aboveEditor` | Set where the toolbar is displayed (above or below the editor)
**videoExtensions** | `List<String>` | `null` | Allowed extensions when inserting videos

#### Styling Options

Parameter | Type | Default | Description
------------ | ------------- | ------------- | -------------
**renderBorder** | `bool` | `false` | Render a border around dropdowns and buttons
**textStyle** | `TextStyle` | `null` | The `TextStyle` to use when displaying dropdowns and buttons
**separatorWidget** | `Widget` | `VerticalDivider(indent: 2, endIndent: 2, color: Colors.grey)` | Set the widget that separates each group of buttons/dropdowns
**renderSeparatorWidget** | `bool` | `true` | Whether or not the separator widget should be rendered
**toolbarItemHeight** | `double` | `36` | Set the height of dropdowns and buttons. Buttons will maintain a square aspect ratio.
**gridViewHorizontalSpacing** | `double` | `5` | The horizontal spacing to use between button groups when displaying the toolbar as `ToolbarType.nativeGrid`
**gridViewVerticalSpacing** | `double` | `5` | The vertical spacing to use between button groups when diplaying the toolbar as `ToolbarType.nativeGrid`

#### Styling Options - applies to dropdowns only

Parameter | Type | Default
------------ | ------------- | -------------
**dropdownElevation** | `int` | `8` 
**dropdownIcon** | `Widget` | `null` 
**dropdownIconColor** | `Color` | `null`
**dropdownIconSize** | `double` | `24`
**dropdownItemHeight** | `double` | `kMinInteractiveDimension` (`48`)
**dropdownFocusColor** | `Color` | `null` 
**dropdownBackgroundColor** | `Color` | `null` 
**dropdownMenuDirection** | `DropdownMenuDirection` | `null`
**dropdownMenuMaxHeight** | `double` | `null` 
**dropdownBoxDecoration** | `BoxDecoration` | `null`

#### Styling Options - applies to buttons only

Parameter | Type | Default
------------ | ------------- | -------------
**buttonColor** | `Color` | `null` 
**buttonSelectedColor** | `Color` | `null` 
**buttonFillColor** | `Color` | `null`
**buttonFocusColor** | `Color` | `null`
**buttonHighlightColor** | `Color` | `null`
**buttonHoverColor** | `Color` | `null` 
**buttonSplashColor** | `Color` | `null` 
**buttonBorderColor** | `Color` | `null` 
**buttonSelectedBorderColor** | `Color` | `null`
**buttonBorderRadius** | `BorderRadius` | `null`
**buttonBorderWidth** | `double` | `null`

### Parameters - `Other Options`

Parameter | Type | Default | Description
------------ | ------------- | ------------- | -------------
**decoration** | `BoxDecoration` | `null` | `BoxDecoration` that surrounds the widget
**height** | `double` | `null` | Height of the widget (includes toolbar and editing area)

### Methods

Access these methods like this: `<controller name>.<method name>`

Method | Argument(s) | Returned Value(s) | Description
------------ | ------------- | ------------- | -------------
**addNotification()** | `String` html, `NotificationType` notificationType | N/A | Adds a notification to the bottom of the editor with the provided HTML content. `NotificationType` determines how it is styled.
**clear()** | N/A | N/A | Resets the HTML editor to its default state
**clearFocus()** | N/A | N/A | Clears focus for the webview and resets the height to the original height on mobile. Do *not* use this method in Flutter Web.
**disable()** | N/A | N/A | Disables the editor (a gray mask is applied and all touches are absorbed)
**enable()** | N/A | N/A | Enables the editor
**execCommand()** | `String` command, `String` argument (optional) | N/A | Allows you to run any `execCommand` command easily. See the [MDN Docs](https://developer.mozilla.org/en-US/docs/Web/API/Document/execCommand) for usage.
**getText()** | N/A | `Future<String>` | Returns the current HTML in the editor
**getSelectedTextWeb()** | `bool` (optional) | `Future<String>` | Get the currently selected text in the editor, with or without the HTML tags. Do *not* use this method in Flutter Mobile.
**insertHtml()** | `String` | N/A | Inserts the provided HTML string into the editor at the current cursor position. Do *not* use this method for plaintext strings.
**insertLink()** | `String` text, `String` url, `bool` isNewWindow | N/A | Inserts a hyperlink using the provided text and url into the editor at the current cursor position. `isNewWindow` defines whether a new browser window is launched if the link is tapped.
**insertNetworkImage()** | `String` url, `String` filename (optional) | N/A | Inserts an image using the provided url and optional filename into the editor at the current cursor position. The image must be accessible via a URL.
**insertText()** | `String` | N/A | Inserts the provided text into the editor at the current cursor position. Do *not* use this method for HTML strings.
**recalculateHeight()** | N/A | N/A | Recalculates the height of the editor by re-evaluating `document.body.scrollHeight`
**redo()** | N/A | N/A | Redoes the last command in the editor
**reloadWeb()** | N/A | N/A | Reloads the webpage in Flutter Web. This is mainly provided to refresh the text editor theme when the theme is changed. Do *not* use this method in Flutter Mobile.
**removeNotification()** | N/A | N/A | Removes the current notification from the bottom of the editor
**resetHeight()** | N/A | N/A | Resets the height of the webview to the original height. Do *not* use this method in Flutter Web.
**setHint()** | `String` | N/A | Sets the current hint text of the editor
**setFocus()** | N/A | N/A | If the pointer is in the webview, the focus will be set to the editor box
**setFullScreen()** | N/A | N/A | Sets the editor to take up the entire size of the webview
**setText()** | `String` | N/A | Sets the current text in the HTML to the input HTML string
**toggleCodeview()** | N/A | N/A | Toggles between the code view and the rich text view
**undo()** | N/A | N/A | Undoes the last command in the editor

### Callbacks

Every callback is defined as a `Function(<parameters in some cases>)`. See the [documentation](https://pub.dev/documentation/html_editor_enhanced/latest/) for more specific details on each callback.
 
Callback | Parameter(s) | Description
------------ | ------------- | -------------
**onBeforeCommand** | `String` | Called before certain commands are called (like undo and redo), passes the HTML in the editor before the command is called
**onChangeContent** | `String` | Called when the content of the editor changes, passes the current HTML in the editor
**onChangeCodeview** | `String` | Called when the content of the codeview changes, passes the current code in the codeview
**onChangeSelection** | `EditorSettings` | Called when the current selection of the editor changes, passes all editor settings (e.g. bold/italic/underline, color, text direction, etc).
**onDialogShown** | N/A | Called when either the image, link, video, or help dialogs are shown
**onEnter** | N/A | Called when enter/return is pressed
**onFocus** | N/A | Called when the rich text field gains focus
**onBlur** | N/A | Called when the rich text field or the codeview loses focus
**onBlurCodeview** | N/A | Called when the codeview either gains or loses focus
**onImageLinkInsert** | `String` | Called when an image is inserted via URL, passes the URL of the image
**onImageUpload** | `FileUpload` | Called when an image is inserted via upload, passes `FileUpload` which holds filename, date modified, size, and MIME type
**onImageUploadError** | `FileUpload`, `String`, `UploadError` | Called when an image fails to inserted via upload, passes `FileUpload` which may hold filename, date modified, size, and MIME type (or be null), `String` which is the base64 (or null), and `UploadError` which describes the type of error
**onInit** | N/A | Called when the rich text field is initialized and JavaScript methods can be called
**onKeyDown** | `int` | Called when a key is downed, passes the keycode of the downed key
**onKeyUp** | `int` | Called when a key is released, passes the keycode of the released key
**onMouseDown** | N/A | Called when the mouse/finger is downed
**onMouseUp** | N/A | Called when the mouse/finger is released
**onNavigationRequestMobile** | `String` | Called when the URL of the webview is about to change on mobile only
**onPaste** | N/A | Called when content is pasted into the editor
**onScroll** | N/A | Called when editor box is scrolled

### Getters

1) `<controller name>.editorController`. This returns the `InAppWebViewController`, which manages the webview that displays the editor.

This is extremely powerful, as it allows you to create your own custom methods and implementations directly in your app. See [`flutter_inappwebview`](https://github.com/pichillilorenzo/flutter_inappwebview) for documentation on the controller.

This getter *should not* be used in Flutter Web. If you are making a cross platform implementation, please use `kIsWeb` to check the current platform in your code.

2) `<controller name>.characterCount`. This returns the number of text characters in the editor.

### Toolbar

This API allows you to customize the toolbar in a nice, readable format.

By default, the toolbar will have all buttons enabled except the "other file" button, because the plugin cannot handle those files out of the box.

Here's what that a custom implementation could look like:

```dart
HtmlEditorController controller = HtmlEditorController();
Widget htmlEditor = HtmlEditor(
  controller: controller, //required
  //other options
  toolbarOptions: HtmlToolbarOptions(
    defaultToolbarButtons: [
        StyleButtons(),
        ParagraphButtons(lineHeight: false, caseConverter: false)
    ]
  )
);
```

If you leave the `Toolbar` constructor blank (like `Style()` above), then the package interprets that you want all the buttons for the `Style` group to be visible.

If you want to remove certain buttons from the group, you can set their button name to `false`, as shown in the example above.

Order matters! Whatever group you set first will be the first group of buttons to display.

If you don't want to show an entire group of buttons, simply don't include their constructor in the `Toolbar` list! This means that if you want to disable just one button, you still have to provide all other constructors.

You can also create your own toolbar buttons! See [below](#customtoolbarbuttons-and-customtoolbarbuttonsinsertionindices) for more details.

### Plugins

This API allows you to add certain Summernote plugins from the [Summernote Awesome library](https://github.com/summernote/awesome-summernote).

Currently the following plugins are supported:

1. [Summernote Case Converter](https://github.com/piranga8/summernote-case-converter) -
Convert the selected text to all lowercase, all uppercase, sentence case, or title case. Supported via a dropdown in the toolbar in `ParagraphButtons`.

2. [Summernote List Styles](https://github.com/tylerecouture/summernote-list-styles) -
Customize the ul and ol list style. Supported via a dropdown in the toolbar in `ListButtons`.

3. [Summernote RTL](https://github.com/virtser/summernote-rtl-plugin) -
Switch the currently selected text between LTR and RTL format. Supported via two buttons in the toolbar in `ParagraphButtons`.

4. [Summernote At Mention](https://github.com/team-loxo/summernote-at-mention) -
Shows a dropdown of available mentions when the '@' character is typed into the editor. The implementation requires that you pass a list of available mentions, and you can also provide a function to call when a mention is inserted into the editor.

5. [Summernote File](https://github.com/mathieu-coingt/summernote-file) -
Support picture files (jpg, png, gif, wvg, webp), audio files (mp3, ogg, oga), and video files (mp4, ogv, webm) in base64. Supported via the image/audio/video/other file buttons in the toolbar in `InsertButtons`.

This list is not final, more can be added. If there's a specific plugin you'd like to see support for, please file a feature request!

No plugins are activated activated by default. They can be activated by modifying the toolbar items, see [above](#toolbar) for details.

To activate Summernote At Mention:

```dart
HtmlEditorController controller = HtmlEditorController();
Widget htmlEditor = HtmlEditor(
  controller: controller, //required
  //other options
  plugins: [
    SummernoteAtMention(
      //returns the dropdown items on mobile
      getSuggestionsMobile: (String value) {
        List<String> mentions = ['test1', 'test2', 'test3'];
        return mentions
            .where((element) => element.contains(value))
            .toList();
      },
      //returns the dropdown items on web
      mentionsWeb: ['test1', 'test2', 'test3'],
      onSelect: (String value) {
        print(value);
      }
    ),
  ]
);
```

### `HtmlEditorOptions` parameters

This section contains longer descriptions for select parameters in `HtmlEditorOptions`. For parameters not mentioned here, see the parameters table [above](#parameters---htmleditoroptions) for a short description. If you have further questions, please file an issue.

#### `autoAdjustHeight`

Default value: true

This option parameter sets the height of the editor automatically by getting the value returned by the JS `document.body.scrollHeight` and the toolbar `GlobalKey` (`toolbarKey.currentContext?.size?.height`). 

This is useful because the toolbar could have either 1 - 5 rows depending on the widget's configuration, screen size, orientation, etc. There is no reliable way to tell how large the toolbar is going to be until after `build()` is executed, and thus simply hardcoding the height of the webview can induce either empty space at the bottom or a scrollable webview. By using the JS and a `GlobalKey` on the toolbar widget, the editor can get the exact height and update the widget to reflect that.

There is a drawback: The webview will visibly shift size after the page is loaded. Depending on how large the change is, it could be jarring. Sometimes, it takes a second for the webview to adjust to the new size and you might see the editor page jump down/up a second or two after the webview container adjusts itself.

If this does not help your use case feel free to disable it, but the recommended value is `true`.

#### `adjustHeightForKeyboard`

Default value: true, only considered on mobile

This option parameter changes the height of the editor if the keyboard is active and it overlaps with the editor. 

This is useful because webviews do not shift their view when the keyboard is active on Flutter at the moment. This means that if your editor spans the height of the page, if the user types a long text they might not be able to see what they are typing because it is obscured by the keyboard.

When this parameter is enabled, the webview will shift to the perfect height to ensure all the typed content is visible, and as soon as the keyboard is hidden, the editor shifts back to its original height.

The webview does take a moment to shift itself back and forth after the keyboard pops up/keyboard disappears, but the delay isn't too bad. It is highly recommended to have the webview in a `Scrollable`  and `shouldEnsureVisible` enabled if there are other widgets on the page - if the editor is on the bottom half of the page it will be scrolled to the top and then the height will be set accordingly, rather than the plugin trying to set the height for a webview obscured completely by the keyboard.

See [below](#example-for-adjustheightforkeyboard) for an example use case.

If this does not help your use case feel free to disable it, but the recommended value is `true`.

#### `filePath`

This option parameter allows you to fully customize what HTML is loaded into the webview, by providing a file path to a custom HTML file from assets.

There is a particular format that is required/recommended when providing a file path for web, because the web implementation will load the HTML as a `String` and make changes to it directly using `replaceAll().`, rather than using a method like `evaluateJavascript()` - because that does not exist on Web.

On Web, you should include the following:

1. `<!--darkCSS-->` inside `<head>` - this enables dark mode support

2. `<!--headString-->` inside `<body>` and below your summernote `<div>` - this allows the JS and CSS files for any enabled plugins to be loaded

3. `<!--summernoteScripts-->` inside `<body>` and below your summernote `<div>` - REQUIRED - this allows Dart and JS to communicate with each other. If you don't include this, then methods/callbacks will do nothing. 

Notes:

1. Do *not* initialize the Summernote editor in your custom HTML file! The package will take care of that.

2. Make sure to set the `id` for Summernote to `summernote-2`! - `<div id="summernote-2"></div>`.

3. Make sure to include jquery and the Summernote JS/CSS in your file! The package does not do this for you.<br><br>
You can use these files from the package to avoid adding more asset files:

```html
<script src="assets/packages/html_editor_enhanced/assets/jquery.min.js"></script>
<link href="assets/packages/html_editor_enhanced/assets/summernote-lite.min.css" rel="stylesheet">
<script src="assets/packages/html_editor_enhanced/assets/summernote-lite.min.js"></script>
```

See the example HTML file [below](#example-html-for-filepath) for an actual example.

#### `shouldEnsureVisible`

Default value: false

This option parameter will scroll the editor container into view whenever the webview is focused or text is typed into the editor. 

You can only use this parameter if your `HtmlEditor` is inside a `Scrollview`, otherwise it does nothing.

This is useful in cases where the page is a `SingleChildScrollView` or something similar with multiple widgets (eg a form). When the user is going through the different fields, it will pop the webview into view, just like a `TextField` would scroll into in view if text is being typed inside it. 

See [below](#example-for-shouldensurevisible) for an example with a good way to use this.

#### `webInitialScripts`

This parameter allows you to specify custom JavaScript for the editor on Web. These can be called at any point in time using `controller.evaluateJavascriptWeb`.

You must add these scripts using the `WebScript` class, which takes a `name` and a `script` argument. `name` *must* be a unique identifier, otherwise your desired script may not be executed. Pass your JavaScript code in the `script` argument.

The package supports returning values from JavaScript as well. You should run `var result = await controller.evaluateJavascriptWeb(<name>, hasReturnValue: true);`.

To get the return value, you must add the following at the end of your JavaScript:

```javascript
window.parent.postMessage(JSON.stringify({"type": "toDart: <WebScript name goes here>", <add any other params you wish to return here>}), "*");
```

You can view a complete example [below](#example-for-webinitialscripts)

### `HtmlToolbarOptions` parameters

This section contains longer descriptions for select parameters in `HtmlToolbarOptions`. For parameters not mentioned here, see the parameters table [above](#parameters---htmltoolbaroptions) for a short description. If you have further questions, please file an issue.

#### `customToolbarButtons` and `customToolbarButtonsInsertionIndices`

These two parameters allow you to insert custom buttons and set where they are inserted into the toolbar widget list.

This would look something like this:

```dart
HtmlEditorController controller = HtmlEditorController();
Widget htmlEditor = HtmlEditor(
  controller: controller, //required
  //other options
  toolbarOptions: HtmlToolbarOptions(
    defaultToolbarButtons: [
      StyleButtons(),
      FontSettingButtons(),
      FontButtons(),
      ColorButtons(),
      ListButtons(),
      ParagraphButtons(),
      InsertButtons(),
      OtherButtons(),
    ],
    customToolbarButtons: [
      //your widgets here
      Button1(),
      Button2(),
    ],
    customToolbarInsertionIndices: [2, 5]
  )
);
```

In the above example, we have defined two buttons to be inserted at indices 2 and 5. These buttons will *not* be inserted before `FontSettingButtons` and before `ListButtons`, respectively! Each default button group may have a few different sub-groups:

Button Group | Number of Subgroups 
------------ | -------------
`StyleButtons` | 1
`FontSettingButtons` | 3
`FontButtons` | 2
`ColorButtons` | 1
`ListButtons` | 2
`ParagraphButtons` | 5
`InsertButtons` | 1
`OtherButtons` | 2

If some of your buttons are deactivated, the number of subgroups could be reduced. The insertion index depends on these subgroups rather than the overall button group. An easy way to count the insertion index is to build the app and count the number of separator spaces between each button group/dropdown before the location you want to insert your button.

So with this in mind, `Button1` will be inserted between the first two subgroups in `FontSettingButtons`, and `Button2` will be inserted between the two subgroups in `FontButtons`.

When creating an `onPressed`/`onTap`/`onChanged` method for your widget, you can use `controller.execCommand` or any of the other methods on the controller to perform actions in the editor. 

Notes:
 
1. using `controller.editorController.<method>` will do nothing on Web!

2. If you don't provide `customToolbarButtonsInsertionIndices`, the plugin will insert your buttons at the end of the default toolbar list

3. If you provide `customToolbarButtonsInsertionIndices`, it ***must*** be the same length as your `customToolbarButtons` widget list.

#### `linkInsertInterceptor`, `mediaLinkInsertInterceptor`, `otherFileLinkInsert`, `mediaUploadInterceptor`, and `onOtherFileUpload`

These callbacks help you intercept any links or files being inserted into the editor.

Parameter | Type | Description
------------ | ------------- | -------------
**linkInsertInterceptor** | `FutureOr<bool> Function(String, String, bool)` | Intercept any links inserted into the editor. The function passes the display text (`String`), the URL (`String`), and whether it opens a new tab (`bool`).
**mediaLinkInsertInterceptor** | `FutureOr<bool> Function(String, InsertFileType)` | Intercept any media links inserted into the editor. The function passes the URL (`String`).
**mediaUploadInterceptor** | `FutureOr<bool> Function(PlatformFile, InsertFileType)` | Intercept any media files inserted into the editor. The function passes `PlatformFile` which holds all relevant file data. You can use this to upload into your server, to extract base64 data, perform file validation, etc. It also passes the file type (image/audio/video).
**onOtherFileLinkInsert** | `Function(String)` | Intercept file link inserts other than image/audio/video. This handler is required when using the other file button, as the package has no built-in handlers. The function passes the URL (`String`). It also passes the file type (image/audio/video)
**onOtherFileUpload** | `Function(PlatformFile)` | Intercept file uploads other than image/audio/video. This handler is required when using the other file button, as the package has no built-in handlers. The function passes `PlatformFile` which holds all relevant file data. You can use this to upload into your server, to extract base64 data, perform file validation, etc.

For `linkInsertInterceptor`, `mediaLinkInsertInterceptor`, and `mediaUploadInterceptor`, you must return a `bool` to tell the plugin what it should do. When you return false, it assumes that you have handled the user request and taken action. When you return true, the plugin will use the default handlers to handle the user request.

`onOtherFileLinkInsert` and `onOtherFileUpload` are required when using the "other file" button. This button isn't active by default, so if you make it active, you must provide these functions, otherwise nothing will happen when the user inserts a file other than image/audio/video.

See [below](#example-for-linkinsertinterceptor-medialinkinsertinterceptor-otherfilelinkinsert-mediauploadinterceptor-and-onotherfileupload) for an example.

#### `onButtonPressed` and `onDropdownChanged`

These callbacks help you intercept any button presses or dropdown changes.

Parameter | Type | Description
------------ | ------------- | -------------
**onButtonPressed** | `FutureOr<bool> Function(ButtonType, bool?, void Function()?)` | Intercept any button presses. The function passes the enum for the pressed button, the current selected status of the button (if applicable) and a function to update the status (if applicable).
**onDropdownChanged** | `FutureOr<bool> Function(DropdownType, dynamic, void Function(dynamic)?)` | Intercept any dropdown changes. The function passes the enum for the changed dropdown, the changed value, and a function to update the changed value (if applicable).

You must return a `bool` to tell the plugin what it should do. When you return false, it assumes that you have handled the user request and taken action. When you return true, the plugin will use the default handlers to handle the user request.

Some buttons and dropdowns, such as copy/paste and the case converter, don't need to update their changed value, so functions to update the value after handling the user request will not be provided for those buttons.

See [below](#example-for-onbuttonpressed-and-ondropdownchanged) for an example.

#### Custom toolbar position using `ToolbarPosition.custom`

You can use `toolbarPosition: ToolbarPosition.custom` and the `ToolbarWidget()` widget to fully customize exactly where you want to place the toolbar. THe possibilities are endless - you could place the toolbar in a sticky header using Slivers, you could decide to show/hide the toolbar whenever you please, or you could make the toolbar into a floating, draggable widget!

`ToolbarWidget()` requires the `HtmlEditorController` you created for the editor itself, along with the `HtmlToolbarOptions` you supplied to the `Html` constructor. These can be simply copy-pasted, no changed necessary.

A basic example where the toolbar is placed in a different location than normal:

```dart
HtmlEditorController controller = HtmlEditorController();
Widget column = Column(
  mainAxisAlignment: MainAxisAlignment.center,
  children: <Widget>[
    HtmlEditor(
      controller: controller,
      htmlEditorOptions: HtmlEditorOptions(
        hint: 'Your text here...',
        shouldEnsureVisible: true,
        //initialText: "<p>text content initial, if any</p>",
      ),
      htmlToolbarOptions: HtmlToolbarOptions(
        toolbarPosition: ToolbarPosition.custom, //required to place toolbar anywhere!
        //other options
      ),
      otherOptions: OtherOptions(height: 550),
    ),
    //other widgets here
    Widget1(),
    Widget2(),
    ToolbarWidget(
      controller: controller,
      htmlToolbarOptions: HtmlToolbarOptions(
        toolbarPosition: ToolbarPosition.custom, //required to place toolbar anywhere!
        //other options
      ),
    )
  ]
);
```

### `HtmlEditorController` Parameters

#### `processInputHtml`, `processOutputHtml`, and `processNewLineAsBr`

Default values: true, true, false, respectively

`processInputHtml` replaces any occurrences of `"` with `\\"`, `'` with `\\'`, and `\r`, `\r\n`, `\n`, and `\n\n` with empty strings. This is necessary to prevent syntax exceptions when inserting HTML into the editor as quotes and other special characters will not be escaped. If you have already sanitized and escaped all relevant characters from your HTML input, it is recommended to set this parameter `false`. You may also want to set this parameter `false` on Web, as in testing it seems these characters are handled correctly by default, but that may not be the case for your HTML.

`processOutputHtml` replaces the output HTML with `""` if: 

1. It is empty

2. It is `<p></p>`

3. It is `<p><br></p>`

4. It is `<p><br/></p>`

These may seem a little random, but they are the three possible default/initial HTML codes the Summernote editor will have. If you'd like to still receive these outputs, set the parameter `false`.

`processNewLineAsBr` will replace `\n` and `\n\n` with `<br/>`. This is only recommended when inserting plaintext as the initial value. In typical HTML any new-lines are ignored, and therefore this parameter defaults to `false`.

## Examples

See the [example app](https://github.com/tneotia/html-editor-enhanced/blob/master/example/lib/main.dart) to see how the majority of methods & callbacks can be used. You can also play around with the parameters to see how they function.

This section will be updated later with more specialized and specific examples as this library grows and more features are implemented.

### Example for `linkInsertInterceptor`, `mediaLinkInsertInterceptor`, `otherFileLinkInsert`, `mediaUploadInterceptor`, and `onOtherFileUpload`:

<details><summary>Example code</summary>

Note: This example uses the [http](https://pub.dev/packages/http) package.

```dart
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;

  Widget editor = HtmlEditor(
    controller: controller,
    toolbarOptions: ToolbarOptions(
      mediaLinkInsertInterceptor: (String url, InsertFileType type) {
        if (url.contains(website_url)) {
          controller.insertNetworkImage(url);
        } else {
          controller.insertText("This file is invalid!");
        }
        return false;
      },
      mediaUploadInterceptor: (PlatformFile file, InsertFileType type) async {
        print(file.name); //filename
        print(file.size); //size in bytes
        print(file.extension); //MIME type (e.g. image/jpg)
        //either upload to server:
        if (file.bytes != null && file.name != null) {
          final request = http.MultipartRequest('POST', Uri.parse("your_server_url"));
          request.files.add(http.MultipartFile.fromBytes("file", file.bytes, filename: file.name)); //your server may require a different key than "file"
          final response = await request.send();
          //try to insert as network image, but if it fails, then try to insert as base64:
          if (response.statusCode == 200) {
            controller.insertNetworkImage(response.body["url"], filename: file.name!); //where "url" is the url of the uploaded image returned in the body JSON
          } else {
            if (type == InsertFileType.image) {
              String base64Data = base64.encode(file.bytes!);
              String base64Image =
              """<img src="data:image/${file.extension};base64,$base64Data" data-filename="${file.name}"/>""";
              controller.insertHtml(base64Image);
            } else if (type == InsertFileType.video) {
              String base64Data = base64.encode(file.bytes!);
              String base64Image =
              """<video src="data:video/${file.extension};base64,$base64Data" data-filename="${file.name}"/>""";
              controller.insertHtml(base64Image);
            } else if (type == InsertFileType.audio) {
              String base64Data = base64.encode(file.bytes!);
              String base64Image =
              """<audio src="data:audio/${file.extension};base64,$base64Data" data-filename="${file.name}"/>""";
              controller.insertHtml(base64Image);
            }
          }
        }
        //or insert as base64:
        if (file.bytes != null) {
          if (type == InsertFileType.image) {
            String base64Data = base64.encode(file.bytes!);
            String base64Image =
            """<img src="data:image/${file.extension};base64,$base64Data" data-filename="${file.name}"/>""";
            controller.insertHtml(base64Image);
          } else if (type == InsertFileType.video) {
            String base64Data = base64.encode(file.bytes!);
            String base64Image =
            """<video src="data:video/${file.extension};base64,$base64Data" data-filename="${file.name}"/>""";
            controller.insertHtml(base64Image);
          } else if (type == InsertFileType.audio) {
            String base64Data = base64.encode(file.bytes!);
            String base64Image =
            """<audio src="data:audio/${file.extension};base64,$base64Data" data-filename="${file.name}"/>""";
            controller.insertHtml(base64Image);
          }
        }
        return false;
      },
    ),
  );
```

`linkInsertInterceptor`, `onOtherFileLinkInsert`, and `onOtherFileUpload` can be implemented in a very similar way, except those do not use the `InsertFileType` enum in their function.

`onOtherFileLinkInsert` and `onOtherFileUpload` also do not require a `bool` to be returned.

</details>

### Example for `onButtonPressed` and `onDropdownChanged`

<details><summary>Example code</summary>

```dart
  Widget editor = HtmlEditor(
    controller: controller,
    toolbarOptions: ToolbarOptions(
      onButtonPressed: (ButtonType type, bool? status, Function()? updateStatus) {
        print("button '${describeEnum(type)}' pressed, the current selected status is $status");
        //run a callback and return false and update the status, otherwise
        return true;
      },
      onDropdownChanged: (DropdownType type, dynamic changed, Function(dynamic)? updateSelectedItem) {
        print("dropdown '${describeEnum(type)}' changed to $changed");
        //run a callback and return false and update the changed value, otherwise
        return true;
      },
    ),
  );
```

</details>

### Example for `adjustHeightForKeyboard`:

<details><summary>Example code</summary>

```dart
class _HtmlEditorExampleState extends State<HtmlEditorExample> {
  final HtmlEditorController controller = HtmlEditorController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!kIsWeb) {
          // this is extremely important to the example, as it allows the user to tap any blank space outside the webview,
          // and the webview will lose focus and reset to the original height as expected. 
          controller.clearFocus();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              //other widgets
              HtmlEditor(
                controller: controller,
                htmlEditorOptions: HtmlEditorOptions(
                  shouldEnsureVisible: true,
                  //adjustHeightForKeyboard is true by default
                  hint: "Your text here...",
                  //initialText: "<p>text content initial, if any</p>",
                ),
                otherOptions: OtherOptions(
                  height: 550,c
                ),
              ),
              //other widgets
            ],
          ),
        ),
      ),
    );
  }
}
```

</details>

### Example for `shouldEnsureVisible`:

<details><summary>Example code</summary>

```dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:html_editor_enhanced/html_editor.dart';

class _ExampleState extends State<Example> {
  final HtmlEditorController controller = HtmlEditorController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!kIsWeb) {
          //these lines of code hide the keyboard and clear focus from the webview when any empty
          //space is clicked. These are very important for the shouldEnsureVisible to work as intended.
          SystemChannels.textInput.invokeMethod('TextInput.hide');
          controller.editorController!.clearFocus();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          elevation: 0,
          actions: [
            IconButton(
               icon: Icon(Icons.check),
               tooltip: "Save",
               onPressed: () {
                  //save profile details
               }
            ),
          ]   
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 18, right: 18),
                child: TextField(
                  controller: titleController,
                  textInputAction: TextInputAction.next,
                  focusNode: titleFocusNode,
                  decoration: InputDecoration(
                      hintText: "Name",
                      border: InputBorder.none
                  ),
                ),
              ),
              SizedBox(height: 16),
              HtmlEditor(
                controller: controller,
                htmlEditorOptions: HtmlEditorOptions(
                  shouldEnsureVisible: true,
                  hint: "Description",
                ),
                otherOptions: OtherOptions(
                  height: 450,
                ),
              ),
              SizedBox(height: 16),
              Padding(
                padding: EdgeInsets.only(left: 18, right: 18),
                child: TextField(
                  controller: bioController,
                  textInputAction: TextInputAction.next,
                  focusNode: bioFocusNode,
                  decoration: InputDecoration(
                    hintText: "Bio",
                    border: InputBorder.none
                  ),
                ),
              ),
              Image.network("path_to_profile_picture"),
              IconButton(
                 icon: Icon(Icons.edit, size: 35),
                 tooltip: "Edit profile picture",
                 onPressed: () async {
                    //open gallery and make api call to update profile picture   
                 }
              ),
              //etc... just a basic form.
            ],
          ),
        ),
      ),
    );
  }
}
```

</details>

### Example HTML for `filePath`:

<details><summary>Example HTML</summary>

```html
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />
    <meta name="description" content="Flutter Summernote HTML Editor">
    <meta name="author" content="tneotia">
    <title>Summernote Text Editor HTML</title>
    <script src="assets/packages/html_editor_enhanced/assets/jquery.min.js"></script>
    <link href="assets/packages/html_editor_enhanced/assets/summernote-lite.min.css" rel="stylesheet">
    <script src="assets/packages/html_editor_enhanced/assets/summernote-lite.min.js"></script>
    <!--darkCSS-->
</head>
<body>
<div id="summernote-2"></div>
<!--headString-->
<!--summernoteScripts-->
<style>
  body {
      display: block;
      margin: 0px;
  }
  .note-editor.note-airframe, .note-editor.note-frame {
      border: 0px solid #a9a9a9;
  }
  .note-frame {
      border-radius: 0px;
  }
</style>
</body>
</html>
```

</details>

### Example for `webInitialScripts`:

<details><summary>View code</summary>

```dart
  String result = '';
  final HtmlEditorController controller = HtmlEditorController();
  final FocusNode node = FocusNode();

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
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              HtmlEditor(
                controller: controller,
                htmlEditorOptions: HtmlEditorOptions(
                  darkMode: false,
                  webInitialScripts: UnmodifiableListView([
                    WebScript(name: "editorBG", script: "document.getElementsByClassName('note-editable')[0].style.backgroundColor='blue';"),
                    WebScript(name: "height", script: """
                      var height = document.body.scrollHeight;
                      window.parent.postMessage(JSON.stringify({"type": "toDart: height", "height": height}), "*");
                    """),
                  ])
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextButton(
                      style: TextButton.styleFrom(
                          backgroundColor: Colors.blueGrey),
                      onPressed: () {
                        controller.evaluateJavascriptWeb("editorBG");
                      },
                      child:
                          Text('Change Background', style: TextStyle(color: Colors.white)),
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                          backgroundColor: Colors.blueGrey),
                      onPressed: () async {
                        var result = await controller.evaluateJavascriptWeb("height", hasReturnValue: true);
                        print(result); // prints "{type: toDart: height, height: 561}"
                      },
                      child:
                          Text('Get Height', style: TextStyle(color: Colors.white)),
                    ),
                  ]
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
```

</details>

## Notes

Due to this package depending on a webview for rendering the HTML editor, there will be some general weirdness in how the editor behaves. Unfortunately, these are not things I can fix, they are inherent problems with how webviews function on Flutter.

If you do find any issues, please report them in the Issues tab and I will see if a fix is possible, but if I close the issue it is likely due to the above fact.

1. When switching between dark and light mode, a reload is required for the HTML editor to switch to the correct color scheme. You can implement this programmatically in Flutter Mobile: `<controller name>.editorController.reload()`, or in Flutter Web: `<controller name>.reloadWeb()`. This will reset the editor! You can save the current text, reload, and then set the text if you'd like to maintain the state.

2. If you are making a cross platform implementation and are using either the `editorController` getter or the `reloadWeb()` method, use `kIsWeb` in your app to ensure you are calling these in the correct platform.

## FAQ

<details><summary>View answered questions</summary>

* How can I display the final output of the editor? - Examples given for both raw HTML output and rendered HTML output - https://github.com/tneotia/html-editor-enhanced/issues/2

* How can I set the editor to "fullscreen" by default? - https://github.com/tneotia/html-editor-enhanced/issues/4

* The editor does not accept any key inputs when using the iOS Simulator. How can I fix this? - https://github.com/tneotia/html-editor-enhanced/issues/7

* Clicking on the editor makes the cursor appear on the second line relative with the hint. Is there a workaround? - https://github.com/tneotia/html-editor-enhanced/issues/24

* How can I give the editor box a custom background color on mobile? - https://github.com/tneotia/html-editor-enhanced/issues/27
  
* I see a file upload button in the top left of my application on Web. How can I remove it? - https://github.com/tneotia/html-editor-enhanced/issues/28
  
* I can't tap drawer items above the text editor on Web. How can I fix this? - https://github.com/tneotia/html-editor-enhanced/issues/30
  
* How can I remove the "dragbar" at the bottom of the editor? - https://github.com/tneotia/html-editor-enhanced/issues/42
  
* How can I detect if an image has been deleted from the editor? - https://github.com/tneotia/html-editor-enhanced/issues/43
  
* How can I handle editor focus? - https://github.com/tneotia/html-editor-enhanced/issues/47
  
* How can I set the default text direction for the editor content? - https://github.com/tneotia/html-editor-enhanced/issues/49
  
* How can I handle relative URLs for images in my initial text? - https://github.com/tneotia/html-editor-enhanced/issues/50

* How can I give the editor box a custom background color on web? - https://github.com/tneotia/html-editor-enhanced/issues/57
  
* How can I create a toolbar dropdown for custom fonts? - https://github.com/tneotia/html-editor-enhanced/issues/59
  
* How can I translate things like dialog text? - https://github.com/tneotia/html-editor-enhanced/issues/69
  
* How can I disable copy/paste buttons from the toolbar? - https://github.com/tneotia/html-editor-enhanced/issues/71
  
* How can I extract image tag from the editor HTML? - https://github.com/tneotia/html-editor-enhanced/issues/72

* How can I use LaTeX or math formulas in the editor? - https://github.com/tneotia/html-editor-enhanced/issues/74

* How can I make a custom button outside of the toolbar to make text bold? - https://github.com/tneotia/html-editor-enhanced/issues/81

* How can I style the `<blockquote>` element differently? - https://github.com/tneotia/html-editor-enhanced/issues/83

* How can I set image width to 100% by default? - https://github.com/tneotia/html-editor-enhanced/issues/86

* How can I override link opening on mobile? - https://github.com/tneotia/html-editor-enhanced/issues/88

* How can I set the initial font family in the editor? - https://github.com/tneotia/html-editor-enhanced/issues/125

* How can I change background color of toolbar only? - https://github.com/tneotia/html-editor-enhanced/issues/94

* How can I pick images from gallery directly without showing the dialog? - https://github.com/tneotia/html-editor-enhanced/issues/97
  
</details>

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contribution Guide

> Coming soon!
>
> Meanwhile, PRs are always welcome

Original html_editor by [xrb21](https://github.com/xrb21) - [repo link](https://github.com/xrb21/flutter-html-editor). Credits for the original idea and original base code to him. This library is a fork of his repo.
