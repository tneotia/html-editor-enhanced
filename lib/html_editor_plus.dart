library html_editor_plus;

export 'core.dart';

export 'editor_field.dart';

export 'src/plus/editor/html_editor_unsupported.dart'
    if (dart.library.html) 'src/plus/editor/html_editor_web.dart'
    if (dart.library.io) 'src/plus/editor/html_editor_mobile.dart';
export 'src/plus/editor_controller.dart' show HtmlEditorController;
