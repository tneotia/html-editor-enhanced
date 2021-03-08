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