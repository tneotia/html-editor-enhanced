import 'package:flutter/foundation.dart';
import 'package:html_editor_enhanced/html_editor.dart';

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

/// Summernote @ Mention plugin - adds a dropdown to select the person to mention whenever
/// the '@' character is typed into the editor. The list of people to mention is
/// drawn from the [getSuggestionsMobile] (on mobile) or [mentionsWeb] (on Web)
/// parameter. You can detect who was mentioned using the [onSelect] callback.
///
/// README available [here](https://github.com/team-loxo/summernote-at-mention)
class SummernoteAtMention extends Plugins {
  /// Function used to get the displayed suggestions on mobile
  final List<String> Function(String)? getSuggestionsMobile;

  /// List of mentions to display on Web. The default behavior is to only return
  /// the mentions containing the string entered by the user in the editor
  final List<String>? mentionsWeb;

  /// Callback to run code when a mention is selected
  final Function(String)? onSelect;

  const SummernoteAtMention({
    this.getSuggestionsMobile,
    this.mentionsWeb,
    this.onSelect}) :
        assert(kIsWeb ? mentionsWeb != null : getSuggestionsMobile != null);

  @override
  String getHeadString() {
    return "<script src=\"assets/packages/html_editor_enhanced/assets/plugins/summernote-at-mention/bundle.js\"></script>";
  }

  @override
  String getToolbarString() {
    return "";
  }

  String getMentionsWeb() {
    String mentionsString = "[";
    for (String e in mentionsWeb!) {
      mentionsString =
          mentionsString + "'$e'" + (e != mentionsWeb!.last ? ", " : "");
    }
    return mentionsString + "]";
  }
}

/// Summernote codewrapper plugin - adds a button to the toolbar to wrap the selected
/// text in a code box.
///
/// README available [here](https://github.com/semplon/summernote-ext-codewrapper)
class SummernoteCodewrapper extends Plugins {
  const SummernoteCodewrapper();

  @override
  String getHeadString() {
    return "<script src=\"assets/packages/html_editor_enhanced/assets/plugins/summernote-codewrapper/summernote-ext-codewrapper.min.js\"></script>";
  }

  @override
  String getToolbarString() {
    return "gxcode";
  }
}

/// Summernote file plugin - adds a button to the toolbar to upload any type of file.
/// By default it can handle picture files (jpg, png, gif, wvg, webp),
/// audio files (mp3, ogg, oga), and video files (mp4, ogv, webm) without any
/// upload in base64. If you want to handle other files, you must upload them
/// into a server and insert it into the editor using the onFileUpload function.
///
/// README available [here](https://github.com/mathieu-coingt/summernote-file)
class SummernoteFile extends Plugins {
  /// Set the max file size for uploads, if exceeded, [onFileUploadError] is called
  final int maximumFileSize;

  /// Define what to do when a file is uploaded. This will override the default handler so you must insert the file into the editor manually
  final Function(FileUpload)? onFileUpload;

  /// Define what to do when a file is inserted via a link. This will override the default handler so you must insert the file yourself
  final Function(String)? onFileLinkInsert;

  /// Define what to do when a file fails to insert for any reason
  final Function(FileUpload?, String?, UploadError)? onFileUploadError;

  const SummernoteFile(
      {this.maximumFileSize = 10485760,
      this.onFileUpload,
      this.onFileLinkInsert,
      this.onFileUploadError});

  @override
  String getHeadString() {
    return "<script src=\"assets/packages/html_editor_enhanced/assets/plugins/summernote-file/summernote-file.js\"></script>";
  }

  @override
  String getToolbarString() {
    return "file";
  }
}

/// Defines the 3 different cases for file insertion failing
enum UploadError { unsupportedFile, exceededMaxSize, jsException }
