
import 'dart:convert';

import 'package:html_editor_enhanced/src/models/parsed_highlight.dart';

class TextHighLight {
  final String text;
  final int? lineNo;
  final Map<String,String>? css;
  final void Function(ParsedHighlight parsedHighlight,void Function(String) replacer)? onTap;
  final String? id;

  TextHighLight({required this.text, this.lineNo, this.css, this.onTap,this.id});
  
  Map<String,dynamic> toJson() {
    var highlightJson = <String,dynamic>{};
    highlightJson['text'] = text;
    highlightJson['lineNo'] = lineNo;
    highlightJson['css'] = css != null ? css!.entries.map((e) => '${e.key}:${e.value}').join(';') : null;
    highlightJson['id'] = id;
    return highlightJson;
  }

  static TextHighLight fromJson(Map<String, dynamic> json) {
    var cssParsed = <String,String>{};
    if(json['css'] != null){
      var splitCss = (json['css'] as String).split(':');
      for(var i=0;i<splitCss.length;i+=2){
        cssParsed[splitCss[i]] = splitCss[i+1].replaceAll(';', '');
      }
    }
    return TextHighLight(text: json['text'],css: cssParsed,lineNo: json['lineNo'],id: json['id']);
  }



  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TextHighLight &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}