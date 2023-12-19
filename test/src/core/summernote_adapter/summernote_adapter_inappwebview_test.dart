import 'package:flutter_test/flutter_test.dart';
import 'package:html_editor_enhanced/src/core/summernote_adapter/summernote_adapter_inappwebview.dart';

void main() {
  group(
    "SummernoteAdapterInappWebView tests:",
    () {
      test("onBeforeCommandCallback returns correct string", () {
        final adapter = SummernoteAdapterInappWebView(key: "key");
        expect(
          adapter.onBeforeCommandCallback.replaceAll(" ", "").replaceAll("\n", ""),
          equals(
            '\$(\'#summernote-2\').on(\'summernote.before.command\',function(_,contents){window.flutter_inappwebview.callHandler("onBeforeCommand",contents);});',
          ),
        );
      });

      test("onChangeCodeviewCallback returns correct string", () {
        final adapter = SummernoteAdapterInappWebView(key: "key");
        expect(
          adapter.onChangeCodeviewCallback.replaceAll(" ", "").replaceAll("\n", ""),
          equals(
            '\$(\'#summernote-2\').on(\'summernote.change.codeview\',function(_,contents){window.flutter_inappwebview.callHandler("onChangeCodeview",contents);});',
          ),
        );
      });

      test("onDialogShownCallback returns correct string", () {
        final adapter = SummernoteAdapterInappWebView(key: "key");
        expect(
          adapter.onDialogShownCallback.replaceAll(" ", "").replaceAll("\n", ""),
          equals(
            '\$(\'#summernote-2\').on(\'summernote.dialog.shown\',function(){window.flutter_inappwebview.callHandler("onDialogShown",\'fired\');});',
          ),
        );
      });

      test("onEnterCallback returns correct string", () {
        final adapter = SummernoteAdapterInappWebView(key: "key");
        expect(
          adapter.onEnterCallback.replaceAll(" ", "").replaceAll("\n", ""),
          equals(
            '\$(\'#summernote-2\').on(\'summernote.enter\',function(){window.flutter_inappwebview.callHandler("onEnter",\'fired\');});',
          ),
        );
      });

      test("onFocusCallback returns correct string", () {
        final adapter = SummernoteAdapterInappWebView(key: "key");
        expect(
          adapter.onFocusCallback.replaceAll(" ", "").replaceAll("\n", ""),
          equals(
            '\$(\'#summernote-2\').on(\'summernote.focus\',function(){window.flutter_inappwebview.callHandler("onFocus",\'fired\');});',
          ),
        );
      });

      test("onBlurCallback returns correct string", () {
        final adapter = SummernoteAdapterInappWebView(key: "key");
        expect(
          adapter.onBlurCallback.replaceAll(" ", "").replaceAll("\n", ""),
          equals(
            '\$(\'#summernote-2\').on(\'summernote.blur\',function(){window.flutter_inappwebview.callHandler("onBlur",\'fired\');});',
          ),
        );
      });

      test("onBlurCodeviewCallback returns correct string", () {
        final adapter = SummernoteAdapterInappWebView(key: "key");
        expect(
          adapter.onBlurCodeviewCallback.replaceAll(" ", "").replaceAll("\n", ""),
          equals(
            '\$(\'#summernote-2\').on(\'summernote.blur.codeview\',function(){window.flutter_inappwebview.callHandler("onBlurCodeview",\'fired\');});',
          ),
        );
      });

      test("onKeyDownCallback returns correct string", () {
        final adapter = SummernoteAdapterInappWebView(key: "key");
        expect(
          adapter.onKeyDownCallback.replaceAll(" ", "").replaceAll("\n", ""),
          equals(
            '\$(\'#summernote-2\').on(\'summernote.keydown\',function(_,e){window.flutter_inappwebview.callHandler("onKeyDown",e.keyCode);});',
          ),
        );
      });

      test("onKeyUpCallback returns correct string", () {
        final adapter = SummernoteAdapterInappWebView(key: "key");
        expect(
          adapter.onKeyUpCallback.replaceAll(" ", "").replaceAll("\n", ""),
          equals(
            '\$(\'#summernote-2\').on(\'summernote.keyup\',function(_,e){window.flutter_inappwebview.callHandler("onKeyUp",e.keyCode);});',
          ),
        );
      });

      test("onMouseDownCallback returns correct string", () {
        final adapter = SummernoteAdapterInappWebView(key: "key");
        expect(
          adapter.onMouseDownCallback.replaceAll(" ", "").replaceAll("\n", ""),
          equals(
            '\$(\'#summernote-2\').on(\'summernote.mousedown\',function(_){window.flutter_inappwebview.callHandler("onMouseDown",\'fired\');});',
          ),
        );
      });

      test("onMouseUpCallback returns correct string", () {
        final adapter = SummernoteAdapterInappWebView(key: "key");
        expect(
          adapter.onMouseUpCallback.replaceAll(" ", "").replaceAll("\n", ""),
          equals(
            '\$(\'#summernote-2\').on(\'summernote.mouseup\',function(_){window.flutter_inappwebview.callHandler("onMouseUp",\'fired\');});',
          ),
        );
      });

      test("onPasteCallback returns correct string", () {
        final adapter = SummernoteAdapterInappWebView(key: "key");
        expect(
          adapter.onPasteCallback.replaceAll(" ", "").replaceAll("\n", ""),
          equals(
            '\$(\'#summernote-2\').on(\'summernote.paste\',function(_){window.flutter_inappwebview.callHandler("onPaste",\'fired\');});',
          ),
        );
      });

      test("onScrollCallback returns correct string", () {
        final adapter = SummernoteAdapterInappWebView(key: "key");
        expect(
          adapter.onScrollCallback.replaceAll(" ", "").replaceAll("\n", ""),
          equals(
            '\$(\'#summernote-2\').on(\'summernote.scroll\',function(_){window.flutter_inappwebview.callHandler("onScroll",\'fired\');});',
          ),
        );
      });

      test("onImageLinkInsertCallback returns correct string", () {
        final adapter = SummernoteAdapterInappWebView(key: "key");
        expect(
          adapter.onImageLinkInsertCallback.replaceAll(" ", "").replaceAll("\n", ""),
          equals(
            'onImageLinkInsert:function(url){window.flutter_inappwebview.callHandler("onImageLinkInsert",url);}',
          ),
        );
      });

      test("onImageUploadCallback returns correct string", () {
        final adapter = SummernoteAdapterInappWebView(key: "key");
        expect(
          adapter.onImageUploadCallback.replaceAll(" ", "").replaceAll("\n", ""),
          equals(
            'onImageUpload:function(files){constreader=newFileReader();letbase64="<anerroroccurred>";reader.onload=function(_){base64=reader.result;constnewObject={\'lastModified\':files[0].lastModified,\'lastModifiedDate\':files[0].lastModifiedDate,\'name\':files[0].name,\'size\':files[0].size,\'type\':files[0].type,\'base64\':base64};window.flutter_inappwebview.callHandler("onImageUpload",JSON.stringify(newObject));};reader.onerror=function(_){constnewObject={\'lastModified\':files[0].lastModified,\'lastModifiedDate\':files[0].lastModifiedDate,\'name\':files[0].name,\'size\':files[0].size,\'type\':files[0].type,\'base64\':base64};window.flutter_inappwebview.callHandler("onImageUpload",JSON.stringify(newObject));};reader.readAsDataURL(files[0]);}',
          ),
        );
      });

      test("onImageUploadErrorCallback returns correct string", () {
        final adapter = SummernoteAdapterInappWebView(key: "key");
        expect(
          adapter.onImageUploadErrorCallback.replaceAll(" ", "").replaceAll("\n", ""),
          equals(
            'onImageUploadError:function(file,error){if(typeoffile===\'string\'){window.flutter_inappwebview.callHandler("onImageUploadError",file,error);}else{constnewObject={\'lastModified\':file.lastModified,\'lastModifiedDate\':file.lastModifiedDate,\'name\':file.name,\'size\':file.size,\'type\':file.type,};window.flutter_inappwebview.callHandler("onImageUploadError",JSON.stringify(newObject),error);}}',
          ),
        );
      });
    },
  );
}
