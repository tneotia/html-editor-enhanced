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
      <link href="assets/packages/html_editor_enhanced/assets/plugins/additional-text-tags/summernote-add-text-tags.css" rel="stylesheet">
      <script src="assets/packages/html_editor_enhanced/assets/plugins/additional-text-tags/summernote-add-text-tags.js"></script>
    """;
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
/// README available [here](https://github.com/DiemenDesign/summernote-classes)
class SummernoteClasses extends Plugins {
  const SummernoteClasses();

  @override
  String getHeadString() {
    return "<script src=\"assets/packages/html_editor_enhanced/assets/plugins/summernote-classes/summernote-classes.js\"></script>";
  }

  @override
  String getToolbarString() {
    return "classes";
  }
}

/// Summernote case converter plugin - adds a toolbar item that can convert any text
/// between cases. The supported cases are upper, lower, sentence, and title.
///
/// README available [here](https://github.com/piranga8/summernote-case-converter)
class SummernoteCaseConverter extends Plugins {
  const SummernoteCaseConverter();

  @override
  String getHeadString() {
    return "<script src=\"assets/packages/html_editor_enhanced/assets/plugins/summernote-case-converter/summernote-case-converter.js\"></script>";
  }

  @override
  String getToolbarString() {
    return "caseConverter";
  }
}

/// Summernote list styles plugin - adds a toolbar item that allows the user to
/// change the bulleted list style.
/// Available styles: numbered, lowered alpha, upper alpha, lower roman, upper
/// roman, disc, circle, and square.
///
/// README available [here](https://github.com/tylerecouture/summernote-list-styles)
class SummernoteListStyles extends Plugins {
  const SummernoteListStyles();

  @override
  String getHeadString() {
    return """
      <link href="assets/packages/html_editor_enhanced/assets/plugins/summernote-list-styles/summernote-list-styles.css" rel="stylesheet">
      <script src="assets/packages/html_editor_enhanced/assets/plugins/summernote-list-styles/summernote-list-styles.js"></script>
    """;
  }

  @override
  String getToolbarString() {
    return "";
  }
}

/// Summernote RTL plugin - adds two toolbar items that let you switch between
/// LTR and RTL format, useful for languages like Hebrew and Arabic.
///
/// README available [here](https://github.com/virtser/summernote-rtl-plugin)
class SummernoteRTL extends Plugins {
  const SummernoteRTL();

  @override
  String getHeadString() {
    return "<script src=\"assets/packages/html_editor_enhanced/assets/plugins/summernote-rtl/summernote-ext-rtl.js\"></script>";
  }

  @override
  String getToolbarString() {
    return "ltr', 'rtl";
  }
}