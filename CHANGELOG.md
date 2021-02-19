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