/**

 *
 */

(function (factory) {
    /* global define */
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

    // Extends plugins for emoji plugin.
    $.extend($.summernote.plugins, {

        'add-text-tags': function (context) {
            var self = this;
            var ui = $.summernote.ui;
            var options = context.options;

            self.generateBtn = function(tag, tooltip) {
                var char = tag.slice(0,1).toUpperCase();
                return ui.button({
                    contents: '<'+tag+'>'+char+'</'+tag+'>',
                    tooltip: tooltip + ' <' + tag + '>',
                    className: 'note-add-text-tags-btn',
                    click: function (e) {
                        self.wrapInTag(tag);
                    }
                });
            };


            var del = self.generateBtn('del', 'Deleted text');
            var ins = self.generateBtn('ins', 'Inserted text');
            var small = self.generateBtn('small', 'Fine print');
            var mark = self.generateBtn('mark', 'Highlighted text');
            var variable = self.generateBtn('var', 'Variable');
            var keyboard = self.generateBtn('kbd', 'User input');
            var code = self.generateBtn('code', 'Inline code');
            var samp = self.generateBtn('samp', 'Sample output');


            context.memo('button.add-text-tags', function () {
                return ui.buttonGroup([
                    ui.button({
                        className: 'dropdown-toggle',
                        contents: '<b>+</b> ' + ui.icon(options.icons.caret, 'span'),
                        tooltip: 'Additional text styles',
                        data: {
                            toggle: 'dropdown'
                        }
                    }),
                    ui.dropdown([
                        ui.buttonGroup({
                            className: 'note-add-text-tags-code',
                            children: [code, samp, keyboard, variable]
                        }),
                        ui.buttonGroup({
                            className: 'note-add-text-tags-other',
                            children: [mark, small, ins, del]
                        })
                    ])
                ]).render();
            });

            self.areDifferentBlockElements = function(startEl, endEl) {
                var startElDisplay = getComputedStyle(startEl, null).display;
                var endElDisplay  = getComputedStyle(endEl, null).display;

                if(startElDisplay !== 'inline' && endElDisplay !== 'inline') {
                    console.log("Can't insert across two block elements.")
                    return true;
                }
                else {
                    return false;
                }
            };

            self.isSelectionParsable = function(startEl, endEl) {

                if(startEl.isSameNode(endEl)) {
                    return true;
                }
                if( self.areDifferentBlockElements(startEl, endEl)) {
                    return false;
                }
                // if they're not different block elements, then we need to check if they share a common block ancestor
                // could do this recursively, if we want to back farther up the node chain...
                var startElParent = startEl.parentElement;
                var endElParent = endEl.parentElement;
                if( startEl.isSameNode(endElParent)
                    || endEl.isSameNode(startElParent)
                    || startElParent.isSameNode(endElParent) )
                {
                    return true;
                }
                else
                    console.log("Unable to parse across so many nodes. Sorry!")
                    return false;
            };

            self.wrapInTag = function (tag) {
                // from: https://github.com/summernote/summernote/pull/1919#issuecomment-304545919
                // https://github.com/summernote/summernote/pull/1919#issuecomment-304707418

                if (window.getSelection) {
                    var selection = window.getSelection(),
                        selected = (selection.rangeCount > 0) && selection.getRangeAt(0);

                    // Only wrap tag around selected text
                    if (selected.startOffset !== selected.endOffset) {

                        var range = selected.cloneRange();

                        var startParentElement = range.startContainer.parentElement;
                        var endParentElement = range.endContainer.parentElement;

                        // if the selection starts and ends different elements, we could be in trouble
                        if( ! startParentElement.isSameNode(endParentElement)) {
                            if ( ! self.isSelectionParsable(startParentElement, endParentElement)) {
                                return;
                            }
                        }

                        var newNode = document.createElement(tag);
                        // https://developer.mozilla.org/en-US/docs/Web/API/Range/surroundContents
                        // Parses inline nodes, but not block based nodes...blocks are handled above.
                        newNode.appendChild(range.extractContents());
                        range.insertNode(newNode)

                        // Restore the selections
                        range.selectNodeContents(newNode);
                        selection.removeAllRanges();
                        selection.addRange(range);
                    }
                }
            };
        }
    });
}));
