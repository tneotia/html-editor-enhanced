import 'package:html_editor_enhanced/src/models/text_highlight.dart';

class ParsedHighlight {
  TextHighLight? highLight;
  int? startIndex;
  int? endIndex;
  String? left;
  String? top;
  String? width;
  String? height;

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
  }

  Map<String, dynamic> toJson() {
    var data = <String, dynamic>{};
    data['startIndex'] = startIndex;
    data['endIndex'] = endIndex;
    data['left'] = left;
    data['top'] = top;
    data['width'] = width;
    data['height'] = height;
    data = {
      ...data,
      ...highLight?.toJson() ?? {}
    };
    return data;
  }
}
