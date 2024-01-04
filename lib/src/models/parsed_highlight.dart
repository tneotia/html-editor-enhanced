import 'package:html_editor_enhanced/src/models/text_highlight.dart';

class ParsedHighlight {
  TextHighLight? highLight;
  int? startIndex;
  int? endIndex;
  String? left;
  String? top;
  String? width;
  String? height;
  String? groupText;
  void Function(String)? replacer;

  ParsedHighlight(
      {this.highLight, this.startIndex, this.endIndex, this.left, this.top, this.width, this.height});

  ParsedHighlight.fromJson(Map<String, dynamic> json) {
    highLight = TextHighLight.fromJson(json);
    startIndex = json['startIndex'];
    endIndex = json['endIndex'];
    left = json['left'];
    top = json['top'];
    width = json['width'];
    height = json['height'];
    groupText = json['groupText'];
  }

  Map<String, dynamic> toJson() {
    var data = <String, dynamic>{};
    data['startIndex'] = startIndex;
    data['endIndex'] = endIndex;
    data['left'] = left;
    data['top'] = top;
    data['width'] = width;
    data['height'] = height;
    data['groupText'] = groupText;
    data = {
      ...data,
      ...highLight?.toJson() ?? {}
    };
    return data;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ParsedHighlight &&
          runtimeType == other.runtimeType &&
          startIndex == other.startIndex &&
          endIndex == other.endIndex &&
          left == other.left &&
          top == other.top &&
          width == other.width &&
          height == other.height &&
          groupText == other.groupText;

  @override
  int get hashCode =>
      startIndex.hashCode ^
      endIndex.hashCode ^
      left.hashCode ^
      top.hashCode ^
      width.hashCode ^
      height.hashCode ^
      groupText.hashCode;
}
