// MaterialUiCompatibilityBridge is deprecated by design: it's a temporary
// migration utility. Remove this file once the dependencies below migrate.
// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart' as legacy;
import 'package:material_ui/material_ui.dart';
import 'package:meta/meta.dart';

/// Hosts widgets from dependencies that still import
/// `package:flutter/material.dart` (currently `flex_color_picker` and
/// `numberpicker`) inside this package's `material_ui` widget tree.
///
/// [MaterialUiCompatibilityBridge] maps the `material_ui` theme and
/// localizations onto their legacy equivalents. The transparent legacy
/// [legacy.Material] satisfies legacy widgets (e.g. `TextField`) that assert a
/// legacy `Material` ancestor, which a `material_ui` `AlertDialog` doesn't
/// provide.
@internal
class LegacyMaterialBridge extends StatelessWidget {
  const LegacyMaterialBridge({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MaterialUiCompatibilityBridge(
      child: legacy.Material(
        type: legacy.MaterialType.transparency,
        child: child,
      ),
    );
  }
}
