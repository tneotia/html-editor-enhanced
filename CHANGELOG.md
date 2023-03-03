## [2.5.1] = 2023-01-25
* Fix build issues on Flutter 3.4.0+ due to assets directory
* Update dependencies

## [2.5.0] - 2022-06-04
* Support Flutter 3.0 (remove warnings) (@Cteq3132)
* [BREAKING] Support modifying `foreColorSelected` and `backColorSelected` when using a custom dialog for font coloring
   * If you are using a custom `updateStatus` function for the font coloring, that function is now defined as `updateStatus(Color)`
* Added `disabled` parameter to automatically disable editor on initial load
* Fixed white background color appearing sometimes when pressing backspace on text
* Added `useHybridComposition` parameter in case devs want to disable this behavior (improves animations of app)
* [WEB] Fixed editor height being 0 when `initialText` is `null` (@dab246)
* Migrated example to Android embedding V2
* Removed woff fonts to allow iOS App Store submissions

## [2.4.0] - 2021-10-30
* Improved color picker
   * Added scrollable support to picker
   * Fixed issue where keyboard would disappear and prevent users from selecting a new color
* Added support for getting selected text in Flutter Web (`controller.getSelectedTextWeb()`)
* Added support for spellcheck
* Added support for custom options in summernote initialization
* Added support for a hard stop on character limit (will not allow user to type further)
* Fixed bug where focusing editor would scroll it back to the top and not show the caret position
* Fixed height not updating in Flutter Web when `callbacks` was `null`
* Updated dependencies and fixed flutter_colorpicker dependency error (@eliudio)

## [2.3.0] - 2021-09-09
* Potentially fixed bad state error for `stream.first`
* Fixed Summernote-@-Mention not inserting text after selecting the dropdown item
* Fixed whitespace after @ sign when inserting a mention
* Add support for overriding URL loading on mobile with `onNavigationRequestMobile` callback
* Hide keyboard when opening color picker dialog
* Use try/catch on `SystemChannel` call on web to prevent exception
* Added a character counter for text in the editor - access via `controller.characterCount`
* Fixed auto adjust height not working in some cases
* Fixed editor height not updating when focused after a TextField was previously focused
* Updated dependencies (@JEuler)

NOTE: If you are on Flutter Beta+, you must use `dependency_overrides` in `pubspec.yaml`!!

```yaml
dependency_overrides:
    flutter_colorpicker: ^0.5.0
```

## [2.2.0+1] - 2021-06-15 (BETA)
* Updated `flutter_colorpicker` to the latest version to fix deprecations on Flutter beta+
* [NOTE] Do not use this version on Flutter stable!

## [2.2.0] - 2021-06-14
* Fixed null safety warnings due to latest `file_picker` version
* Potentially fixed editor controller creating a new instance on widget rebuild
* Fixed issue where custom HTML files would have custom JS replaced with built-in JS
* Fixed darkMode not applying when `filePath` is used on Android
* Fixed "null" text showing as the hint when no hint is given
* Added new `onChangeSelection` callback that passes the editor settings whenever the user changes
their current selection (e.g. tap on a different word, create a new node, select text, etc)
* Added support for custom JS injection on Flutter Web
* Fixed minor bug with automatic height adjustment on mobile
* Added new `ToolbarType.nativeExpandable` which allows the user to switch between the 
scrollview or gridview toolbar on the fly
* Support setting the `inputmode` for the editor, which changes the virtual keyboard display on mobile devices (e.g. number pad, email keyboard, etc)
* [BREAKING] renamed `onChange` callback to `onChangeContent`
* [BREAKING] disabled a lot of the buttons by default, now only around half of the editor buttons
are enabled to improve the UX. You can still re-enable the rest if you want.
* [BREAKING] min Flutter version requirement bumped to 2.2.0

## [2.1.1] - 2021-05-22
* Fixed bottom overflow error on `AlertDialog`s if the screen size is small
* Fixed `StyleButtons(style: false)` would not remove the style dropdown
* Fixed JS/Dart communication hiccup on Web (make sure `postMessage` data is not null)
* Code cleanup

## [2.1.0+1] - 2021-05-11
* Hotfix for `copyWith` not defined for `ScrollBehavior` in v2.1.0

## [2.1.0] - 2021-05-10
* Fixed `setState` and `Stream.first` error on page dispose
* Fixed height adjustment not working
* Fixed `getText` on Web
* Improved dropdown UX when `ToolbarPosition.belowEditor` by opening upwards and making it scrollable after a certain height

## [2.0.1] - 2021-04-28
* Added support for setting custom `UserScript`s on the webview (mobile only)
* Added support for customizing the context menu (menu when user selects text) for the webview (mobile only)
* Added `LongPressGestureRecognizer` to the webview to allow users to select text via a long press (mobile only)
    * You can set the duration before the long press is recognized via `HtmlEditorOptions > mobileLongPressDuration`
* Added support for placing the toolbar wherever using `HtmlToolbarOptions > toolbarPosition: ToolbarPosition.custom`
* See the README if you'd like to use any of these new features. `UserScript` and the context menu customization have external documentation via flutter_inappwebview - the docs are linked in the README.

## [2.0.0+1] - 2021-04-22
* Transitioned to fully native controls! These are extremely customizable and have much better UX than the previous controls.
* [BREAKING] refactored a lot of options into separate constructors
* [BREAKING] refactored toolbar classes, so toolbar customizations will need updating
* Added a bunch of interceptors and callbacks for button presses
* Added the ability to make custom buttons and set their positions
* Added native support for numerous Summernote plugins
   * [BREAKING] removed all Summernote plugins except Summernote @ Mention. The package now supports the majority of plugins out of the box.
   * Reduced package size by removing the Summernote plugin files
   * Reduced size further by using a stripped-down version of Summernote @ Mention libs
* Added `execCommand` to controller to help you create custom toolbar buttons
* Improved automatic height adjustment
* Bumped dependencies
* [BREAKING] Require Flutter 2.0.0+
* As always, see the README for full documentation on these changes
* See the [Migration Guide](https://github.com/tneotia/html-editor-enhanced/wiki/v2.0.0-Migration-Guide) for help migrating your v1.x.x widget code

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