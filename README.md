# Flutter Html Editor Plus
[![pub package](https://img.shields.io/pub/v/html_editor_plus.svg)](https://pub.dev/packages/html_editor_plus)

Flutter HTML Editor Plus is a text editor for Android, iOS, and Web to help write WYSIWYG HTML code with the Summernote JavaScript wrapper.

Original html_editor_plus by [tneotia](https://github.com/tneotia) - [repo link](https://github.com/tneotia/html-editor-enhanced). 
This library is a fork of his repo.

I have removed documentation from this page as most of it will be inside the code itself. In the meantime you can read it in the original repo.

Main goals of this package is to:  
- Keep the package updated to latest stable versions of Flutter and dependencies (Summernote editor included).
- Re-write the package in a more readable and maintanable format.
- Improve functionalities.
- Fix known issues.
- Add support for desktop platforms.

## Setup

Add `html_editor_plus: ^0.0.1` as dependency to your pubspec.yaml.

Make sure to declare internet support inside `AndroidManifest.xml`: `<uses-permission android:name="android.permission.INTERNET"/>`

Additional setup is required on iOS to allow the user to pick files from storage. See [here](https://github.com/miguelpruivo/flutter_file_picker/wiki/Setup#--ios) for more details. 

For images, the package uses `FileType.image`, for video `FileType.video`, for audio `FileType.audio`, and for any other file `FileType.any`. You can just complete setup for the specific buttons you plan to enable in the editor.

## Basic Usage

```dart
import 'package:html_editor/html_editor.dart';

HtmlEditorController controller = HtmlEditorController();

@override Widget build(BuildContext context) {
    return HtmlEditor(
        controller: controller, //required
        htmlEditorOptions: HtmlEditorOptions(
          hint: "Your text here...",
          //initalText: "text content initial, if any",
        ),   
        otherOptions: OtherOptions(
          height: 400,
        ),
    );
}
```

### Important note for Web:

At the moment, there is quite a bit of flickering and repainting when having many UI elements draw over `IframeElement`s. See https://github.com/flutter/flutter/issues/71888 for more details.

The current workaround is to build and/or run your Web app with `flutter run --web-renderer html` and `flutter build web --web-renderer html`.

Follow https://github.com/flutter/flutter/issues/80524 for updates on a potential fix, in the meantime the above solution should resolve the majority of the flickering issues.

## API Reference

For the full API reference, see [here](https://pub.dev/documentation/html_editor_plus/latest/).

For a full example, see [here](https://github.com/vadrian89/html-editor-plus/tree/master/example).

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contribution Guide

PRs are always welcome


