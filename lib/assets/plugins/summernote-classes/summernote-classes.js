/*! summernote-classes v0.2 + includes Bootstrap 4 sample classes */
(function (factory) {
  if (typeof define === 'function' && define.amd) {
    define(['jquery'], factory);
  } else if (typeof module === 'object' && module.exports) {
    module.exports = factory(require('jquery'));
  } else {
    factory(window.jQuery);
  }
}
(function ($) {
  $.extend(true, $.summernote.lang, {
    'en-US': {
      classes: {
        a: [ 'button', 'link', 'primary', 'secondary', 'danger'],
        img: [ 'responsive', 'float-left', 'float-center', 'float-right', 'rounded', 'circle', 'small-shadow', 'shadow', 'large-shadow', 'thumbnail'],
        p: [ 'text-center', 'text-right', 'text-justify', 'text-wrap', 'text-nowrap', 'text-truncate', 'text-break', 'text-lowercase', 'text-uppercase', 'text-capitalize', 'text-monospace', 'lead', 'border'],
      }
    }
  });
  $.extend($.summernote.options, {
    disableTableNesting: false,
    classes: {
      a: [ 'btn' , 'btn-link', 'btn-primary', 'btn-secondary', 'btn-danger'],
      img: [ 'img-fluid', 'float-left', 'float-center', 'float-right', 'rounded', 'rounded-circle', 'shadow-sm', 'shadow' ,'shadow-lg' ,'img-thumbnail'],
      p: [ 'text-center', 'text-right', 'text-justify', 'text-wrap', 'text-nowrap', 'text-truncate', 'text-break', 'text-lowercase', 'text-uppercase', 'text-capitalize', 'text-monospace', 'lead', 'border'],
    }
  });
  $.extend($.summernote.plugins, {
    'classes': function (context) {
      var self = this,
            ui = $.summernote.ui,
         $note = context.layoutInfo.note,
       $editor = context.layoutInfo.editor,
       $editable = context.layoutInfo.editable,
       options = context.options,
          lang = options.langInfo;
      $("head").append('<style>@media all{.note-classes{color:#888;font-weight:400;cursor:pointer;}.note-classes-active{color:#4c4;font-weight:700;}.note-status-output{height:auto!important;}}</style>');
      this.events = {
        'summernote.mousedown': function (we,e) {
          e.stopPropagation();
          var el = e.target;
          var elem = $(":focus");
          var outputText='';
          if (options.disableTableNesting === true) {
            $('.note-toolbar [aria-label="Table"]').prop('disabled', false);
          }
          if (!el.classList.contains('note-editable')) {
            if (options.disableTableNesting === true) {
              if (el.nodeName == 'TD') {
                $('.note-toolbar [aria-label="Table"]').prop('disabled', true);
              }
            }
            outputText += el.nodeName;
            var nN=el.nodeName.toLowerCase();
            if(nN in options.classes) {
              outputText += ' class=&quot;';
              var nNc=options.classes[nN];
              $.each(nNc, function (index, value){
                if(el.classList.contains(options.classes[nN][index])){
                  outputText += '<span class="note-classes note-classes-active"';
                } else {
                  outputText += '<span class="note-classes"';
                }
                outputText += ' data-class="' + options.classes[nN][index] + '"';
                outputText += '>' + lang.classes[nN][index] + ' </span>';
              });
              outputText += '&quot;';
            }
            $editor.find('.note-status-output').html(outputText);
            $('.note-classes').on('click', function(){
              $(this).toggleClass('note-classes-active');
              var classes=$(this).data('class');
              $(el).toggleClass(classes);
            });
          } else if (el.classList.contains('note-editable')) {
            $editor.find('.note-status-output').html('');
          }
        },
        'summernote.codeview.toggled': function (we,e) {
          $editor.find('.note-status-output').html('');
        }
      }
    }
  });
}));
