library html_editor;

import 'package:html_editor_enhanced/src/html_editor_controller_unsupported.dart'
    if (dart.library.html) 'package:html_editor_enhanced/src/html_editor_controller_web.dart'
    if (dart.library.io) 'package:html_editor_enhanced/src/html_editor_controller_mobile.dart';

export 'package:html_editor_enhanced/utils/callbacks.dart';
export 'package:html_editor_enhanced/utils/toolbar.dart';
export 'package:html_editor_enhanced/utils/plugins.dart';
export 'package:html_editor_enhanced/utils/file_upload_model.dart';
export 'package:html_editor_enhanced/utils/options.dart';
export 'package:html_editor_enhanced/utils/toolbar_widget.dart';

export 'package:html_editor_enhanced/src/html_editor_unsupported.dart'
    if (dart.library.html) 'package:html_editor_enhanced/src/html_editor_web.dart'
    if (dart.library.io) 'package:html_editor_enhanced/src/html_editor_mobile.dart';

export 'package:html_editor_enhanced/src/html_editor_controller_unsupported.dart'
    if (dart.library.html) 'package:html_editor_enhanced/src/html_editor_controller_web.dart'
    if (dart.library.io) 'package:html_editor_enhanced/src/html_editor_controller_mobile.dart';

/// Global variable used to get the [InAppWebViewController] of the Html editor
Map<HtmlEditorController, dynamic> controllerMap = {};
