
class TextHighLight {
  final String text;
  final int? lineNo;
  final Map<String,String>? css;

  TextHighLight({required this.text, this.lineNo, this.css});
  
  Map<String,dynamic> toJson() {
    var highlightJson = <String,dynamic>{};
    highlightJson['text'] = text;
    highlightJson['lineNo'] = lineNo;
    highlightJson['css'] = css != null ? css!.entries.map((e) => '${e.key}:${e.value}').join(';') : null;
    return highlightJson;
  }
}