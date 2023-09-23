
class TextHighLight {
  final String text;
  final int? lineNo;
  final Map<String,String>? css;
  final void Function()? onTap;
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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TextHighLight &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}