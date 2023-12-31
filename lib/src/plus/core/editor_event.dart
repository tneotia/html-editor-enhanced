/// Events sent to the editor from the controller.
sealed class EditorEvent {
  final String method;
  final String? payload;

  const EditorEvent(this.method, [this.payload]);

  @override
  bool operator ==(covariant EditorEvent other) {
    if (identical(this, other)) return true;

    return other.method == method && other.payload == payload;
  }

  @override
  int get hashCode => method.hashCode ^ payload.hashCode;

  @override
  String toString() => "EditorEvents(method: $method, payload: $payload)";
}

class EditorSetHtml extends EditorEvent {
  const EditorSetHtml({String? payload}) : super("setHtml", payload);
}

class EditorToggleView extends EditorEvent {
  const EditorToggleView() : super("codeview.toggle");
}

class EditorReset extends EditorEvent {
  const EditorReset() : super("reset");
}

class EditorResizeToParent extends EditorEvent {
  const EditorResizeToParent() : super("resizeToParent");
}

class EditorReload extends EditorEvent {
  const EditorReload() : super("reload");
}

class EditorUndo extends EditorEvent {
  const EditorUndo() : super("undo");
}

class EditorRedo extends EditorEvent {
  const EditorRedo() : super("redo");
}

class EditorEnable extends EditorEvent {
  const EditorEnable() : super("enable");
}

class EditorDisable extends EditorEvent {
  const EditorDisable() : super("disable");
}
