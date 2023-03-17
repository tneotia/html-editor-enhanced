import 'package:html_editor_enhanced/html_editor.dart';

enum SummernoteCleanerAction {
  both,
  button,
  paste,
}

enum SummernoteCleanerKeepTagContents {
  h1,
  h2,
  h3,
  h4,
  h5,
  h6,
  a,
  span,
  table,
  tr,
  th,
  td,
}

enum SummernoteCleanerBadTags {
  applet,
  col,
  colgroup,
  embed,
  noframes,
  noscript,
  script,
  style,
  title,
  table,
}

enum SummernoteCleanerBadAttributes {
  bgcolor,
  border,
  height,
  cellpadding,
  cellspacing,
  lang,
  start,
  style,
  valign,
  width,
}

/// Summernote @ Mention plugin - adds a dropdown to select the person to mention whenever
/// the '@' character is typed into the editor. The list of people to mention is
/// drawn from the [getSuggestionsMobile] (on mobile) or [mentionsWeb] (on Web)
/// parameter. You can detect who was mentioned using the [onSelect] callback.
///
/// README available [here](https://github.com/team-loxo/summernote-at-mention)
class SummernoteCleaner extends Plugins {
  final String? action;
  final List<String>? keepTagContents;
  final List<String>? badTags;
  final List<String>? badAttributes;

  const SummernoteCleaner({
    this.action = 'both',
    this.keepTagContents = const ['span'],

    /// Remove full tags with contents,
    this.badTags,

    /// Remove attributes from tags,
    this.badAttributes,
  });

  factory SummernoteCleaner.byDefault() {
    return SummernoteCleaner(
      action: SummernoteCleanerAction.paste.name,
      keepTagContents: [
        SummernoteCleanerKeepTagContents.span.name,
        SummernoteCleanerKeepTagContents.table.name,
        SummernoteCleanerKeepTagContents.h1.name,
        SummernoteCleanerKeepTagContents.h2.name,
        SummernoteCleanerKeepTagContents.h3.name,
        SummernoteCleanerKeepTagContents.h4.name,
        SummernoteCleanerKeepTagContents.h5.name,
        SummernoteCleanerKeepTagContents.h6.name,
        SummernoteCleanerKeepTagContents.a.name,
      ],
      badTags: [
        SummernoteCleanerBadTags.applet.name,
        SummernoteCleanerBadTags.col.name,
        SummernoteCleanerBadTags.colgroup.name,
        SummernoteCleanerBadTags.embed.name,
        SummernoteCleanerBadTags.noframes.name,
        SummernoteCleanerBadTags.noscript.name,
        SummernoteCleanerBadTags.script.name,
        SummernoteCleanerBadTags.style.name,
        SummernoteCleanerBadTags.title.name,
      ],
      badAttributes: [
        SummernoteCleanerBadAttributes.bgcolor.name,
        SummernoteCleanerBadAttributes.border.name,
        SummernoteCleanerBadAttributes.height.name,
        SummernoteCleanerBadAttributes.cellpadding.name,
        SummernoteCleanerBadAttributes.cellspacing.name,
        SummernoteCleanerBadAttributes.lang.name,
        SummernoteCleanerBadAttributes.start.name,
        SummernoteCleanerBadAttributes.style.name,
        SummernoteCleanerBadAttributes.valign.name,
        SummernoteCleanerBadAttributes.width.name,
      ],
    );
  }

  @override
  String getHeadString() {
    return '<script src=\"assets/packages/html_editor_enhanced/assets/plugins/summernote-cleaner/summernote-cleaner.js\"></script>';
  }

  @override
  String getToolbarString() {
    return '';
  }

  String getMentionsWeb() {
    var mentionsString = '[';
    // for (var e in mentionsWeb!) {
    //   mentionsString =
    //       mentionsString + "'$e'" + (e != mentionsWeb!.last ? ', ' : '');
    // }
    return mentionsString + ']';
  }
}
