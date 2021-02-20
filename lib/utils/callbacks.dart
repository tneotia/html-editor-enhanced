/// Manages all the callback functions the library provides
class Callbacks {
  Callbacks({
    this.onChange,
    this.onEnter,
    this.onFocus,
    this.onBlur,
    this.onBlurCodeview,
    this.onKeyUp,
    this.onKeyDown,
  });

  /// Called whenever the HTML content of the editor is changed and the editor
  /// is in rich text view. There is currently no way to detect changes when
  /// the editor is in code view.
  /// Note: This function also seems to be called if input is detected in the
  /// editor field. E.g. repeatedly pressing backspace when the field is empty
  /// will also trigger this callback.
  ///
  /// This function will return the current HTML in the editor as an argument.
  Function(String) onChange;

  /// Called whenever the enter/return key is pressed and the editor
  /// is in rich text view. There is currently no way to detect enter/return
  /// when the editor is in code view.
  /// Note: The onChange callback will also be triggered at the same time as
  /// this callback, please design your implementation accordingly.
  Function() onEnter;

  /// Called whenever the rich text field gains focus. This will not be called
  /// when the code view editor gains focus, instead use [onBlurCodeview] for
  /// that.
  Function() onFocus;

  /// Called whenever either the rich text field or the codeview field loses
  /// focus. This will also be triggered when switching from the rich text editor
  /// to the code view editor.
  /// Note: Due to the current state of webviews in Flutter, tapping outside
  /// the webview or dismissing the keyboard does not trigger this callback.
  /// This callback will only be triggered if the user taps on an empty space
  /// in the toolbar or switches the view mode of the editor.
  Function() onBlur;

  /// Called whenever the code view either gains or loses focus (the Summernote
  /// docs say this will only be called when the code view loses focus but
  /// in my testing this is not the case). This will also be triggered when
  /// switching between the rich text editor and the code view editor.
  /// Note: Due to the current state of webviews in Flutter, tapping outside
  /// the webview or dismissing the keyboard does not trigger this callback.
  /// This callback will only be triggered if the user taps on an empty space
  /// in the toolbar or switches the view mode of the editor.
  Function() onBlurCodeview;
  //todo image callbacks & init callback

  /// Called whenever a key is downed and the editor is in rich text view.
  ///
  /// This function will return the keycode for the downed key as an argument.
  /// Note: The keycode [is broken](https://stackoverflow.com/questions/36753548/keycode-on-android-is-always-229)
  /// on Android, you will only ever receive 229, 8 (backspace), or 13 (enter)
  /// as a keycode. 8 and 13 only seem to be returned when the editor is empty
  /// and those keys are downed.
  Function(int) onKeyUp;

  /// Called whenever a key is released and the editor is in rich text view.
  ///
  /// This function will return the keycode for the released key as an argument.
  /// Note: The keycode [is broken](https://stackoverflow.com/questions/36753548/keycode-on-android-is-always-229)
  /// on Android, you will only ever receive 229, 8 (backspace), or 13 (enter)
  /// as a keycode. 8 and 13 only seem to be returned when the editor is empty
  /// and those keys are released.
  Function(int) onKeyDown;
}
