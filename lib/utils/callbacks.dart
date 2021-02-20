/// Manages all the callback functions the library provides
class Callbacks {
  Callbacks({
    this.onChange,
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
}
