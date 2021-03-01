import 'package:flutter/foundation.dart';

/// Abstract class that all the plguin classes extend
abstract class Plugins {
  const Plugins();

  /// Provides the JS and CSS tags to be inserted inside <head>. Only used for Web
  String getHeadString();

  /// Provides the toolbar option for the plugin
  String getToolbarString();
}

/// Summernote Emoji from Ajax plugin - loads emojis via Ajax and displays them in a nice
/// dropdown with a search box. This can be useful in desktop environments
/// where users may not know the Win + . shortcut for emojis (or are on an older
/// platform), and want to be able to use those in the editor.
///
/// Note: Emojis are not inserted in unicode but as images
///
/// README available [here](https://github.com/tylerecouture/summernote-ext-emoji-ajax/)
class SummernoteEmoji extends Plugins {
  const SummernoteEmoji();

  @override
  String getHeadString() {
    return """
      <link href="assets/packages/html_editor_enhanced/assets/plugins/summernote-emoji/summernote-ext-emoji-ajax.css" rel="stylesheet">
      <script src="assets/packages/html_editor_enhanced/assets/plugins/summernote-emoji/summernote-ext-emoji-ajax.js"></script>
    """;
  }

  @override
  String getToolbarString() {
    return "emoji";
  }
}

/// Summernote Additional Text Tags plugin - adds another toolbar item for more
/// text items, such as <var>, <kbd>, and <code>.
///
/// Note: There is a limitation with this plugin - the toolbar items do not toggle
/// on/off. The user will have to use the 'clear' button (looks like an eraser)
/// to stop using any of the elements. It also does not use Summernote's parser
/// but can handle basic copy/pasting.
///
/// README available [here](https://github.com/tylerecouture/summernote-add-text-tags)
class AdditionalTextTags extends Plugins {
  const AdditionalTextTags();

  @override
  String getHeadString() {
    return """
      <link href="plugins/additional-text-tags/summernote-add-text-tags.css" rel="stylesheet">
      <script src="plugins/additional-text-tags/summernote-add-text-tags.js"></script>
    """.replaceAll("src=\"", kIsWeb ? "src=\"assets/packages/html_editor_enhanced/assets/" : "src=\"")
        .replaceAll("href=\"", kIsWeb ? "href=\"assets/packages/html_editor_enhanced/assets/" : "href=\"");
  }

  @override
  String getToolbarString() {
    return "add-text-tags";
  }
}

/// Summernote Classes plugin - adds a hotbar at the bottom of the editor
/// to add various inline tags and stylings to certain HTML elements. Most of the
/// tags are fairly obscure and advanced, so I would not recommend this plugin
/// for the average user.
///
/// ReaREADME available [here](https://github.com/DiemenDesign/summernote-classes)
class SummernoteClasses extends Plugins {
  const SummernoteClasses();

  @override
  String getHeadString() {
    return "<script src=\"plugins/summernote-classes/summernote-classes.js\"></script>"
        .replaceAll("src=\"", kIsWeb ? "src=\"assets/packages/html_editor_enhanced/assets/" : "src=\"")
        .replaceAll("href=\"", kIsWeb ? "href=\"assets/packages/html_editor_enhanced/assets/" : "href=\"");
  }

  @override
  String getToolbarString() {
    return "classes";
  }
}