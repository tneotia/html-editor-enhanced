/*
 * Case Converter, a plugin for Summernote.
 * ---
 * The plugin is a button for case convert 
 * between upper, lower, sentence and title case.
 * ---
 * Version 1
 * copyright [2019] [PiraTera].
 * email: piranga8 [at] gmail [dot] com
 * license: GPL
 * 
 */
(function (factory) {
    /* Global define */
    if (typeof define === 'function' && define.amd) {
        // AMD. Register as an anonymous module.
        define(['jquery'], factory);
    } else if (typeof module === 'object' && module.exports) {
        // Node/CommonJS
        module.exports = factory(require('jquery'));
    } else {
        // Browser globals
        factory(window.jQuery);
    }
}(function ($) {
    /**
     * @class plugin.examplePlugin
     *
     * example Plugin
     */
    $.extend(true, $.summernote.lang, {
        'en-US': {
            /* US English(Default Language) */
            caseConverter: {
                title: 'Case Converter',
                lowerCase: 'Lower case.',
                upperCase: 'Upper case.',
                sentenceCase: 'Sentence case.',
                titleCase: 'Title case.'
            }
        },
        'es-ES': {
            caseConverter: {
                title: 'Cambiar tipo de carácter.',
                lowerCase: 'Minúscula.',
                upperCase: 'Mayúsculas.',
                sentenceCase: 'Tipo oración.',
                titleCase: 'Tipo título.'
            }
        }
    });
    $.extend($.summernote.options, {
        caseConverter: {
            icon: 'Aa',
            tooltip: 'Example Plugin Tooltip'
        }
    });

    $.extend($.summernote.plugins, {
        /**
         *  @param {Object} context - context object has status of editor.
         */
        'caseConverter': function (context) {
            var self = this,
            ui = $.summernote.ui, // ui has renders to build ui elements for e.g. you can create a button with 'ui.button'
            $note = context.layoutInfo.note, // Note element
            $editor = context.layoutInfo.editor, // contentEditable element
            $editable = context.layoutInfo.editable, // contentEditable element
            $toolbar = context.layoutInfo.toolbar, // contentEditable element                
            options = context.options, // options holds the Options Information from Summernote and what we extended above. 
            lang = options.langInfo; // lang holds the Language Information from Summernote and what we extended above.
            
            context.memo('button.caseConverter', function () {                        
                
                // Dropdown HTML
                var htmlDropdownList = '';
                htmlDropdownList += '<li><a href="#" data-value="lowerCase">' + lang.caseConverter.lowerCase     + '</a></li>';
                htmlDropdownList += '<li><a href="#" data-value="upperCase">' + lang.caseConverter.upperCase     + '</a></li>';
                htmlDropdownList += '<li><a href="#" data-value="sentenceCase">' + lang.caseConverter.sentenceCase  + '</a></li>';
                htmlDropdownList += '<li><a href="#" data-value="titleCase">' + lang.caseConverter.titleCase     + '</a></li>';
                
                
                
                // create button
                var button = ui.buttonGroup([
                    ui.button({
                        className: 'caseConverter-toggle',
                        contents: options.caseConverter.icon,
                        tooltip: lang.caseConverter.title,
                        data: {
                            toggle: 'dropdown'
                        }
                    }),
                    ui.dropdown({
                        className: 'dropdown-caseConverter',
                        items: htmlDropdownList,
                        click: function (event) {
                            event.preventDefault();
                            var selected = $note.summernote('createRange');
                            if(selected.toString()){
                                var texto;
                                var count = 0;
                                var $button = $(event.target);
                                var value = $button.data('value');
                                var nodes = selected.nodes();
                                for (var i=0; i< nodes.length; ++i) {
                                    if(nodes[i].nodeName == "#text"){
                                        count++;
                                        texto = nodes[i].nodeValue;
                                        nodes[i].nodeValue = texto.toLowerCase();
                                        if(value == 'upperCase'){
                                            nodes[i].nodeValue = texto.toUpperCase();
                                        }
                                        else if(value == 'titleCase' || (value == 'sentenceCase' && count==1)){
                                            nodes[i].nodeValue = texto.charAt(0).toUpperCase() + texto.slice(1).toLowerCase();
                                        }
                                    }
                                }
                            }
                            $("#summernote").summernote("editor.restoreRange");
                            $("#summernote").summernote("editor.focus");
                        }

                    })
                ]);
                return button.render();
            });
                
        }            
    });
}));
