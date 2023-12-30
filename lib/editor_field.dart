library editor_field;

export 'src/plus/editor_field/html_editor_field_unsupported.dart'
    if (dart.library.html) 'src/plus/editor_field/html_editor_field_web.dart'
    if (dart.library.io) 'src/plus/editor_field/html_editor_field_mobile.dart';
