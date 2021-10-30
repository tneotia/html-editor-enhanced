import 'dart:async';

import 'package:html_editor_enhanced/html_editor.dart';
import 'package:html_editor_enhanced/utils/utils.dart';

/// Manages all the callback functions the library provides
class Callbacks {
  Callbacks({
    this.onBeforeCommand,
    this.onChangeContent,
    this.onChangeCodeview,
    this.onChangeSelection,
    this.onDialogShown,
    this.onEnter,
    this.onFocus,
    this.onBlur,
    this.onBlurCodeview,
    this.onImageLinkInsert,
    this.onImageUpload,
    this.onImageUploadError,
    this.onInit,
    this.onKeyUp,
    this.onKeyDown,
    this.onMouseUp,
    this.onMouseDown,
    this.onNavigationRequestMobile,
    this.onPaste,
    this.onScroll,
  });

  /// Called before certain commands are fired and the editor is in rich text view.
  /// There is currently no documentation on this parameter, thus it is
  /// unclear which commands this will fire before.
  ///
  /// This function will return the current HTML in the editor as an argument.
  void Function(String?)? onBeforeCommand;

  /// Called whenever the HTML content of the editor is changed and the editor
  /// is in rich text view.
  ///
  /// Note: This function also seems to be called if input is detected in the
  /// editor field but the content does not change.
  /// E.g. repeatedly pressing backspace when the field is empty
  /// will also trigger this callback.
  ///
  /// This function will return the current HTML in the editor as an argument.
  void Function(String?)? onChangeContent;

  /// Called whenever the code of the editor is changed and the editor
  /// is in code view.
  ///
  /// Note: This function also seems to be called if input is detected in the
  /// editor field but the content does not change.
  /// E.g. repeatedly pressing backspace when the field is empty
  /// will also trigger this callback.
  ///
  /// This function will return the current code in the codeview as an argument.
  void Function(String?)? onChangeCodeview;

  /// Called whenever the selection area of the editor is changed.
  ///
  /// It passes all the editor settings at the current selection as an argument.
  /// This can be used in custom toolbar item implementations, to update your
  /// toolbar item UI when the editor formatting changes.
  void Function(EditorSettings)? onChangeSelection;

  /// Called whenever a dialog is shown in the editor. The dialogs will be either
  /// the link, image, video, or help dialogs.
  void Function()? onDialogShown;

  /// Called whenever the enter/return key is pressed and the editor
  /// is in rich text view. There is currently no way to detect enter/return
  /// when the editor is in code view.
  ///
  /// Note: The onChange callback will also be triggered at the same time as
  /// this callback, please design your implementation accordingly.
  void Function()? onEnter;

  /// Called whenever the rich text field gains focus. This will not be called
  /// when the code view editor gains focus, instead use [onBlurCodeview] for
  /// that.
  void Function()? onFocus;

  /// Called whenever either the rich text field or the codeview field loses
  /// focus. This will also be triggered when switching from the rich text editor
  /// to the code view editor.
  ///
  /// Note: Due to the current state of webviews in Flutter, tapping outside
  /// the webview or dismissing the keyboard does not trigger this callback.
  /// This callback will only be triggered if the user taps on an empty space
  /// in the toolbar or switches the view mode of the editor.
  void Function()? onBlur;

  /// Called whenever the code view either gains or loses focus (the Summernote
  /// docs say this will only be called when the code view loses focus but
  /// in my testing this is not the case). This will also be triggered when
  /// switching between the rich text editor and the code view editor.
  ///
  /// Note: Due to the current state of webviews in Flutter, tapping outside
  /// the webview or dismissing the keyboard does not trigger this callback.
  /// This callback will only be triggered if the user taps on an empty space
  /// in the toolbar or switches the view mode of the editor.
  void Function()? onBlurCodeview;

  /// Called whenever an image is inserted via a link. The function passes the
  /// URL of the image inserted into the editor.
  ///
  /// Note: Setting this function overrides the default summernote image via URL
  /// insertion handler! This means you must manually insert the image using
  /// [controller.insertNetworkImage] in your callback function, otherwise
  /// nothing will be inserted into the editor!
  void Function(String?)? onImageLinkInsert;

  /// Called whenever an image is inserted via upload. The function passes the
  /// [FileUpload] class, containing the filename, size, MIME type, base64 data,
  /// and last modified information so you can upload it into your server.
  ///
  /// Note: Setting this function overrides the default summernote upload image
  /// insertion handler (base64 handler)! This means you must manually insert
  /// the image using [controller.insertNetworkImage] (for uploaded images) or
  /// [controller.insertHtml] (for base64 data) in your callback function,
  /// otherwise nothing will be inserted into the editor!
  void Function(FileUpload)? onImageUpload;

  /// Called whenever an image is failed to be inserted via upload. The function
  /// passes the [FileUpload] class, containing the filename, size, MIME type,
  /// base64 data, and last modified information so you can do error handling.
  void Function(FileUpload?, String?, UploadError)? onImageUploadError;

  /// Called whenever [InAppWebViewController.onLoadStop] is fired on mobile
  /// or when the [IFrameElement.onLoad] stream is fired on web. Note that this
  /// method will also be called on refresh on both platforms.
  ///
  /// You can use this method to set certain properties - e.g. set the editor
  /// to fullscreen mode - as soon as the editor is ready to accept these commands.
  void Function()? onInit;

  /// Called whenever a key is released and the editor is in rich text view.
  ///
  /// This function will return the keycode for the released key as an argument.
  ///
  /// Note: The keycode [is broken](https://stackoverflow.com/questions/36753548/keycode-on-android-is-always-229)
  /// on Android, you will only ever receive 229, 8 (backspace), or 13 (enter)
  /// as a keycode. 8 and 13 only seem to be returned when the editor is empty
  /// and those keys are released.
  void Function(int?)? onKeyUp;

  /// Called whenever a key is downed and the editor is in rich text view.
  ///
  /// This function will return the keycode for the downed key as an argument.
  ///
  /// Note: The keycode [is broken](https://stackoverflow.com/questions/36753548/keycode-on-android-is-always-229)
  /// on Android, you will only ever receive 229, 8 (backspace), or 13 (enter)
  /// as a keycode. 8 and 13 only seem to be returned when the editor is empty
  /// and those keys are downed.
  void Function(int?)? onKeyDown;

  /// Called whenever the mouse/finger is released and the editor is in rich text view.
  void Function()? onMouseUp;

  /// Called whenever the mouse/finger is downed and the editor is in rich text view.
  void Function()? onMouseDown;

  /// Called right before the URL of the webview is changed on mobile. This allows
  /// you to prevent URLs from loading, or launch them externally, for example.
  ///
  /// This function passes the URL to be loaded, and you must return a
  /// `NavigationActionPolicy` to tell the webview what to do.
  FutureOr<NavigationActionPolicy> Function(String)? onNavigationRequestMobile;

  /// Called whenever text is pasted into the rich text field. This will not be
  /// called when text is pasted into the code view editor.
  ///
  /// Note: This will not be called when programmatically inserting HTML into
  /// the editor with [HtmlEditor.insertHtml].
  void Function()? onPaste;

  /// Called whenever the editor is scrolled and it is in rich text view.
  /// Editor scrolled is considered to be the editor box only, not the webview
  /// container itself. Thus, this callback will only fire when the content in
  /// the editor is longer than the editor height. This function can be called
  /// with an explicit scrolling action via the mouse, or also via implied
  /// scrolling, e.g. the enter key scrolling the editor to make new text visible.
  ///
  /// Note: This function will be repeatedly called while the editor is scrolled.
  /// Make sure to factor that into your implementation.
  void Function()? onScroll;
}
