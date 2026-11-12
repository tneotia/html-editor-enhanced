import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:html_editor_enhanced/src/widgets/legacy_material_bridge.dart';
import 'package:material_ui/material_ui.dart';
import 'package:numberpicker/numberpicker.dart';

/// Mirrors the colour and table dialogs in ToolbarWidget: widgets from
/// dependencies still on package:flutter/material.dart, hosted in a
/// material_ui AlertDialog.
Widget _dialogApp(Widget content) {
  return MaterialApp(
    localizationsDelegates: GlobalMaterialLocalizations.delegates,
    home: Scaffold(
      body: AlertDialog(scrollable: true, content: content),
    ),
  );
}

Widget _colorPicker() => ColorPicker(
      color: Colors.black,
      onColorChanged: (_) {},
      enableOpacity: false,
      showColorCode: true,
      colorCodeHasColor: true,
      pickersEnabled: const <ColorPickerType, bool>{ColorPickerType.wheel: true},
    );

Widget _numberPicker() => NumberPicker(
      value: 1,
      minValue: 1,
      maxValue: 10,
      onChanged: (_) {},
    );

void main() {
  testWidgets('legacy ColorPicker renders inside bridge', (tester) async {
    await tester.pumpWidget(
        _dialogApp(LegacyMaterialBridge(child: _colorPicker())));
    expect(tester.takeException(), isNull);
    expect(find.byType(ColorPicker), findsOneWidget);
  });

  testWidgets('legacy NumberPicker renders inside bridge', (tester) async {
    await tester.pumpWidget(
        _dialogApp(LegacyMaterialBridge(child: _numberPicker())));
    expect(tester.takeException(), isNull);
    expect(find.byType(NumberPicker), findsOneWidget);
  });

  testWidgets('legacy ColorPicker fails without bridge', (tester) async {
    await tester.pumpWidget(_dialogApp(_colorPicker()));
    expect(tester.takeException(), isNotNull);
  });
}
