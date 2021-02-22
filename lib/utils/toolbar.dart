import 'package:flutter/foundation.dart';

abstract class Toolbar {
  const Toolbar();

  String getGroupName();

  String getButtons();
}

class Style extends Toolbar {
  final List<StyleButtons> buttons;

  const Style({this.buttons = const []});

  @override
  String getGroupName() {
    return "style";
  }

  @override
  String getButtons() {
    if (buttons.isEmpty) {
      return "['style']";
    } else {
      String list = "[";
      for (StyleButtons e in buttons) {
        list = list + "'${describeEnum(e)}'" + (buttons.last != e ? ", " : "");
      }
      return list + "]";
    }
  }
}

enum StyleButtons {
  style
}

class FontSetting extends Toolbar {
  final List<FontSettingButtons> buttons;

  const FontSetting({this.buttons = const []});

  @override
  String getGroupName() {
    return "fontsettings";
  }

  @override
  String getButtons() {
    if (buttons.isEmpty) {
      return "['fontname', 'fontsize', 'fontsizeunit']";
    } else {
      String list = "[";
      for (FontSettingButtons e in buttons) {
        list = list + "'${describeEnum(e)}'" + (buttons.last != e ? ", " : "");
      }
      return list + "]";
    }
  }
}

enum FontSettingButtons {
  fontname,
  fontsize,
  fontsizeunit,
}

class Font extends Toolbar {
  final List<FontButtons> buttons;

  const Font({this.buttons = const []});

  @override
  String getGroupName() {
    return "font";
  }

  @override
  String getButtons() {
    if (buttons.isEmpty) {
      return "['bold', 'italic', 'underline', 'clear']";
    } else {
      String list = "[";
      for (FontButtons e in buttons) {
        list = list + "'${describeEnum(e)}'" + (buttons.last != e ? ", " : "");
      }
      return list + "]";
    }
  }
}

enum FontButtons {
  bold,
  italic,
  underline,
  clear
}

class MiscFont extends Toolbar {
  final List<MiscFontButtons> buttons;

  const MiscFont({this.buttons = const []});

  @override
  String getGroupName() {
    return "miscfont";
  }

  @override
  String getButtons() {
    if (buttons.isEmpty) {
      return "['strikethrough', 'superscript', 'subscript']";
    } else {
      String list = "[";
      for (MiscFontButtons e in buttons) {
        list = list + "'${describeEnum(e)}'" + (buttons.last != e ? ", " : "");
      }
      return list + "]";
    }
  }
}

enum MiscFontButtons {
  strikethrough,
  superscript,
  subscript
}

class ColorBar extends Toolbar {
  final List<ColorButtons> buttons;

  const ColorBar({this.buttons = const []});

  @override
  String getGroupName() {
    return "color";
  }

  @override
  String getButtons() {
    if (buttons.isEmpty) {
      return "['color', 'forecolor', 'backcolor']";
    } else {
      String list = "[";
      for (ColorButtons e in buttons) {
        list = list + "'${describeEnum(e)}'" + (buttons.last != e ? ", " : "");
      }
      return list + "]";
    }
  }
}

enum ColorButtons {
  color,
  forecolor,
  backcolor
}

class Paragraph extends Toolbar {
  final List<ParagraphButtons> buttons;

  const Paragraph({this.buttons = const []});

  @override
  String getGroupName() {
    return "para";
  }

  @override
  String getButtons() {
    if (buttons.isEmpty) {
      return "['ul', 'ol', 'paragraph', 'height']";
    } else {
      String list = "[";
      for (ParagraphButtons e in buttons) {
        list = list + "'${describeEnum(e)}'" + (buttons.last != e ? ", " : "");
      }
      return list + "]";
    }
  }
}

enum ParagraphButtons {
  ul,
  ol,
  paragraph,
  height
}

class Insert extends Toolbar {
  final List<InsertButtons> buttons;

  const Insert({this.buttons = const []});

  @override
  String getGroupName() {
    return "insert";
  }

  @override
  String getButtons() {
    if (buttons.isEmpty) {
      return "['link', 'picture', 'video', 'table', 'hr']";
    } else {
      String list = "[";
      for (InsertButtons e in buttons) {
        list = list + "'${describeEnum(e)}'" + (buttons.last != e ? ", " : "");
      }
      return list + "]";
    }
  }
}

enum InsertButtons {
  link,
  picture,
  video,
  table,
  hr
}

class Misc extends Toolbar {
  final List<MiscButtons> buttons;

  const Misc({this.buttons = const []});

  @override
  String getGroupName() {
    return "misc";
  }

  @override
  String getButtons() {
    if (buttons.isEmpty) {
      return "['fullscreen', 'codeview', 'undo', 'redo', 'help']";
    } else {
      String list = "[";
      for (MiscButtons e in buttons) {
        list = list + "'${describeEnum(e)}'" + (buttons.last != e ? ", " : "");
      }
      return list + "]";
    }
  }
}

enum MiscButtons {
  fullscreen,
  codeview,
  undo,
  redo,
  help
}