import 'package:flutter_test/flutter_test.dart';
import 'package:html_editor_enhanced/src/core/summernote_adapter/summernote_adapter_web.dart';

void main() {
  group(
    "SummernoteAdapterWeb tests:",
    () {
      test("onBeforeCommandCallback returns correct string", () {
        final adapter = SummernoteAdapterWeb(key: "key");
        expect(
          adapter.onBeforeCommandCallback.replaceAll(" ", "").replaceAll("\n", ""),
          equals(
            '\$(\'#summernote-2\').on(\'summernote.before.command\',function(_,contents,\$editable){window.parent.postMessage(JSON.stringify({"view":"key","type":"toDart:onBeforeCommand","contents":contents}),"*");});',
          ),
        );
      });

      test("onChangeCodeviewCallback returns correct string", () {
        final adapter = SummernoteAdapterWeb(key: "key");
        expect(
          adapter.onChangeCodeviewCallback.replaceAll(" ", "").replaceAll("\n", ""),
          equals(
            '\$(\'#summernote-2\').on(\'summernote.change.codeview\',function(_,contents,\$editable){window.parent.postMessage(JSON.stringify({"view":"key","type":"toDart:onChangeCodeview","contents":contents}),"*");});',
          ),
        );
      });

      test("onDialogShownCallback returns correct string", () {
        final adapter = SummernoteAdapterWeb(key: "key");
        expect(
          adapter.onDialogShownCallback.replaceAll(" ", "").replaceAll("\n", ""),
          equals(
            '\$(\'#summernote-2\').on(\'summernote.dialog.shown\',function(){window.parent.postMessage(JSON.stringify({"view":"key","type":"toDart:onDialogShown"}),"*");});',
          ),
        );
      });

      test("onEnterCallback returns correct string", () {
        final adapter = SummernoteAdapterWeb(key: "key");
        expect(
          adapter.onEnterCallback.replaceAll(" ", "").replaceAll("\n", ""),
          equals(
            '\$(\'#summernote-2\').on(\'summernote.enter\',function(){window.parent.postMessage(JSON.stringify({"view":"key","type":"toDart:onEnter"}),"*");});',
          ),
        );
      });

      test("onFocusCallback returns correct string", () {
        final adapter = SummernoteAdapterWeb(key: "key");
        expect(
          adapter.onFocusCallback.replaceAll(" ", "").replaceAll("\n", ""),
          equals(
            '\$(\'#summernote-2\').on(\'summernote.focus\',function(){window.parent.postMessage(JSON.stringify({"view":"key","type":"toDart:onFocus"}),"*");});',
          ),
        );
      });

      test("onBlurCallback returns correct string", () {
        final adapter = SummernoteAdapterWeb(key: "key");
        expect(
          adapter.onBlurCallback.replaceAll(" ", "").replaceAll("\n", ""),
          equals(
            '\$(\'#summernote-2\').on(\'summernote.blur\',function(){window.parent.postMessage(JSON.stringify({"view":"key","type":"toDart:onBlur"}),"*");});',
          ),
        );
      });

      test("onBlurCodeviewCallback returns correct string", () {
        final adapter = SummernoteAdapterWeb(key: "key");
        expect(
          adapter.onBlurCodeviewCallback.replaceAll(" ", "").replaceAll("\n", ""),
          equals(
            '\$(\'#summernote-2\').on(\'summernote.blur.codeview\',function(){window.parent.postMessage(JSON.stringify({"view":"key","type":"toDart:onBlurCodeview"}),"*");});',
          ),
        );
      });

      test("onKeyDownCallback returns correct string", () {
        final adapter = SummernoteAdapterWeb(key: "key");
        expect(
          adapter.onKeyDownCallback.replaceAll(" ", "").replaceAll("\n", ""),
          equals(
            '\$(\'#summernote-2\').on(\'summernote.keydown\',function(_,e){window.parent.postMessage(JSON.stringify({"view":"key","type":"toDart:onKeyDown","keyCode":e.keyCode}),"*");});',
          ),
        );
      });

      test("onKeyUpCallback returns correct string", () {
        final adapter = SummernoteAdapterWeb(key: "key");
        expect(
          adapter.onKeyUpCallback.replaceAll(" ", "").replaceAll("\n", ""),
          equals(
            '\$(\'#summernote-2\').on(\'summernote.keyup\',function(_,e){window.parent.postMessage(JSON.stringify({"view":"key","type":"toDart:onKeyUp","keyCode":e.keyCode}),"*");});',
          ),
        );
      });

      test("onMouseDownCallback returns correct string", () {
        final adapter = SummernoteAdapterWeb(key: "key");
        expect(
          adapter.onMouseDownCallback.replaceAll(" ", "").replaceAll("\n", ""),
          equals(
            '\$(\'#summernote-2\').on(\'summernote.mousedown\',function(_){window.parent.postMessage(JSON.stringify({"view":"key","type":"toDart:onMouseDown"}),"*");});',
          ),
        );
      });

      test("onMouseUpCallback returns correct string", () {
        final adapter = SummernoteAdapterWeb(key: "key");
        expect(
          adapter.onMouseUpCallback.replaceAll(" ", "").replaceAll("\n", ""),
          equals(
            '\$(\'#summernote-2\').on(\'summernote.mouseup\',function(_){window.parent.postMessage(JSON.stringify({"view":"key","type":"toDart:onMouseUp"}),"*");});',
          ),
        );
      });

      test("onPasteCallback returns correct string", () {
        final adapter = SummernoteAdapterWeb(key: "key");
        expect(
          adapter.onPasteCallback.replaceAll(" ", "").replaceAll("\n", ""),
          equals(
            '\$(\'#summernote-2\').on(\'summernote.paste\',function(_){window.parent.postMessage(JSON.stringify({"view":"key","type":"toDart:onPaste"}),"*");});',
          ),
        );
      });

      test("onScrollCallback returns correct string", () {
        final adapter = SummernoteAdapterWeb(key: "key");
        expect(
          adapter.onScrollCallback.replaceAll(" ", "").replaceAll("\n", ""),
          equals(
            '\$(\'#summernote-2\').on(\'summernote.scroll\',function(_){window.parent.postMessage(JSON.stringify({"view":"key","type":"toDart:onScroll"}),"*");});',
          ),
        );
      });

      test("onImageLinkInsertCallback returns correct string", () {
        final adapter = SummernoteAdapterWeb(key: "key");
        expect(
          adapter.onImageLinkInsertCallback.replaceAll(" ", "").replaceAll("\n", ""),
          equals(
            'onImageLinkInsert:function(url){window.parent.postMessage(JSON.stringify({"view":"key","type":"toDart:onImageLinkInsert","url":url}),"*");}',
          ),
        );
      });

      test("onImageUploadCallback returns correct string", () {
        final adapter = SummernoteAdapterWeb(key: "key");
        expect(
          adapter.onImageUploadCallback.replaceAll(" ", "").replaceAll("\n", ""),
          equals(
            'onImageUpload:function(files){constreader=newFileReader();letbase64="<anerroroccurred>";reader.onload=function(_){base64=reader.result;constnewObject={\'lastModified\':files[0].lastModified,\'lastModifiedDate\':files[0].lastModifiedDate,\'name\':files[0].name,\'size\':files[0].size,\'type\':files[0].type,\'base64\':base64};window.parent.postMessage(JSON.stringify({"view":"key","type":"toDart:onImageUpload","lastModified":files[0].lastModified,"lastModifiedDate":files[0].lastModifiedDate,"name":files[0].name,"size":files[0].size,"mimeType":files[0].type,"base64":base64}),"*");};reader.onerror=function(_){constnewObject={\'lastModified\':files[0].lastModified,\'lastModifiedDate\':files[0].lastModifiedDate,\'name\':files[0].name,\'size\':files[0].size,\'type\':files[0].type,\'base64\':base64};window.parent.postMessage(JSON.stringify({"view":"key","type":"toDart:onImageUpload","lastModified":files[0].lastModified,"lastModifiedDate":files[0].lastModifiedDate,"name":files[0].name,"size":files[0].size,"mimeType":files[0].type,"base64":base64}),"*");};reader.readAsDataURL(files[0]);}',
          ),
        );
      });

      test("onImageUploadErrorCallback returns correct string", () {
        final adapter = SummernoteAdapterWeb(key: "key");
        expect(
          adapter.onImageUploadErrorCallback.replaceAll(" ", "").replaceAll("\n", ""),
          equals(
            'onImageUploadError:function(file,error){if(typeoffile===\'string\'){window.parent.postMessage(JSON.stringify({"view":"key","type":"toDart:onImageUploadError","base64":file,"error":error}),"*");}else{window.parent.postMessage(JSON.stringify({"view":"key","type":"toDart:onImageUploadError","lastModified":file.lastModified,"lastModifiedDate":file.lastModifiedDate,"name":file.name,"size":file.size,"mimeType":file.type,"error":error}),"*");}}',
          ),
        );
      });
    },
  );
}
