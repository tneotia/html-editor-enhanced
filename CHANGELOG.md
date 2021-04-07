## [1.8.0] - 2021-04-07
* Add support for `getSuggestionsMobile` (Summernote @ Mentions Plugin) - allows you to programatically return the list of mentions.
   * Only supported on mobile.
   * [BREAKING] renamed `mentions` to `mentionsWeb` as a result of this change 
* Added support for the remainder of Summernote callbacks:
   * `onBeforeCommand`
   * `onChangeCodeview`
   * `onDialogShown`
   * `onImageUploadError`
   * `onMouseDown`
   * `onMouseUp`
   * `onScroll`
   * See the README for how these work.
* Added a few new functions:
   * recalculateHeight(): recalculates the editor height and applies it
   * addNotification(): adds a notification bar to the bottom of the editor in a specified style with specified text
   * removeNotification(): removes the current notification from the bottom of the editor
* Fixed blank space at the bottom of the editor when `showBottomToolbar: false`
* Fixed 'Android resource linking failed' (bumped flutter_inappwebview to 5.3.1+1)

## [1.7.1] - 2021-03-26
* Fixed bug where initial text would not be inserted and default toolbar would be shown regardless of editor options
* Significantly improved keyboard height detection (detect when keyboard comes up and goes down)
* Adjusted HTML processing algorithm to fix issues where `"` and `'` would not be properly escaped on HTML insertion
   * Added `processNewLineAsBr` - this will replace any `\n` in the input string to `<br/>` rather than the default `""`
   * Applied processing to `setHint()` and `insertHtml()` functions
* Added support for returning the file's base64 data in `onImageUpload` and `onFileUpload`
   * Now you can use `MultipartFile.fromBytes()` to upload to server - [example](https://github.com/tneotia/html-editor-enhanced#example-for-onimageupload-and-onimagelinkinsert)
* Added support for `onFileUploadError` and `onFileLinkInsert` (Summernote File plugin)
* Added support for `maximumFileSize` (Summernote File plugin)
* See the README for more details on these changes

## [1.7.0+1] - 2021-03-22
* Fixed `type 'double' is not a subtype of type 'int?' in type cast` on iOS
   * By extension this fixes the `adjustHeightForKeyboard` not working on iOS
* Fixed `Bad state: Cannot add new events after calling close` exception when disposing the page containing the editor
* Fixed web page not found when inserting a video URL (see [here](https://github.com/summernote/summernote/issues/3252))

## [1.7.0] - 2021-03-17
* [BREAKING]:
   * Refactored `height`, `autoAdjustHeight`, `decoration`, `showBottomToolbar`, and `darkMode` into new `HtmlEditorOptions` class - see README for how to migrate
   * Removed 'Summernote Classes' plugin
   * Sorry for all the breaking changes lately - I think I've finally figured out how I want to do the API design so there should be far less in future releases
* Added `onImageUpload` callback that fires when an image is inserted via `<input type="file">`
* Added `onImageLinkInsert` callback that fires when an image is inserted via URL
* Added `shouldEnsureVisible` that scrolls the editor into view when it is focused or text is typed, kind of like `TextField`s
* Added `adjustHeightForKeyboard` (default true) that adjusts the editor's height when the keyboard is active to ensure no content is cut off by the keyboard
* Added `filePath` which allows you to provide a completely custom HTML file to load
* If you plan on using any of the above, it is highly recommend looking at the README for more details and examples.
* Removed disabled scroll feature since it prevented the editor from scrolling even when the editor content was larger than the height
* Code cleanup

## [1.6.0] - 2021-03-13
* [BREAKING] removed `dispose()` method on controller
   * The editor no longer uses a `Stream` to get text and therefore nothing needs to be disposed
* Added `onInit` callback that fires once the editor is ready to function and accept JS
* Added a few new parameters:
   * `autoAdjustHeight` - for `HtmlEditor`: default true, automatically adjusts the height of the editor to make sure scrolling is not necessary
   * `processInputHtml` - for `HtmlEditorController`: processes input HTML (e.g. new lines become `<br/>`)
   * `processOutputHtml` - for `HtmlEditorController`: processes output HTML (e.g. `<p><br/><p>` becomes `""`)
* Added more plugins:
    * Summernote Case Converter
    * Summernote List Styles
    * Summernote RTL
    * Summernote @ Mention
    * Summernote Codewrapper
    * Summernote File
    * See the README for more details.
* Added shim for dart:ui to remove the `ui.PlatformViewRegistry not found` error
* Added the summernote-no-plugins.html file to load a de-bloated HTML file when no plugins are active
* Fixed bug where two editors would be initialized in the same webview in some cases
* Reduced the size of assets to ~650kb - ~300kb summernote libs, ~350kb plugin libs
* Code cleanup

## [1.5.0+1] - 2021-03-10
* Fixed getText() returning null on mobile for any device

## [1.5.0] - 2021-03-01
* Nullsafety preview
* Added Flutter's Hybrid Composition to the HTML Editor. This significantly improves the keyboard experience on Android.

## [1.4.0] - 2021-03-01
* [BREAKING] removed `HtmlParser` for calling methods, instead you now must pass an `HtmlEditorController` to the plugin (like a `TextField`). All methods are accessible from that controller. See the usage section in the README for an example.
   * This allows you to have multiple independent editors on a page, whereas earlier the package would not know which editor the method should be called on.
* Add support for certain Summernote plugins from [Summernote Awesome](https://github.com/summernote/awesome-summernote). See the README for details on the API and the currently supported plugins.
* Nullsafety pre-release coming soon.

## [1.3.0] - 2021-02-23
* Add official support for Flutter Web
* Add support for modifying the toolbar options. See the README for details on the API.
* Add support for a native dark mode
* Removed image_picker plugin and image button in toolbar because users can insert images via the image button in Summernote
    * [BREAKING] Removed the `imageWidth` and `useBottomSheet` params due to the above change

## [1.2.0+1] - 2021-02-20
* Add support for accessing `InAppWebViewController` via a getter
* Add support for inserting files via the editor dialog itself
* Add methods:
   * toggle code view
   * enable/disable editor
   * undo/redo
   * inserting plaintext/HTML/images/links
* Add callbacks:
   * onChange
   * onEnter
   * onFocus/onBlur/onBlurCodeview
   * onKeyUp/onKeyDown
   * onPaste
* Downgraded dependencies to non-nullsafety to prevent errors
* Updated docs and example app to showcase new features, refer to those for info on the above changes

## [1.1.1] - 2021-02-19
* Minor update to add documentation to code and completely refactor/reorganize code

## [1.1.0] - 2021-02-19
* Switch webview dependency to `flutter_inappwebview`
* Remove localserver, instead get Summernote HTML directly from assets (improves performance and loading speeds)
* [BREAKING] Switch to `StatelessWidget`
   * You no longer need a `GlobalKey` for the `HtmlEditorState`. All of the methods are static and can be called like so:
   ```dart
   HtmlEditor.setEmpty(); 
   ```
* Fix deprecations and update dependencies

## Flutter HTML Editor changes by xrb21
## [1.0.1] - 2020-05-07
* Update Readme usage for iOS

## [1.0.0] - 2020-05-07
* fixing iOS blank screen
* fixing text hint

## [0.0.2+1] - 2020-05-02
* fixing path packages

## [0.0.2] - 2020-05-02
* Change link repo

## [0.0.1] - 2020-05-02
* Initial Release