(function(factory) {
  if (typeof define === "function" && define.amd) {
    define(["jquery"], factory);
  } else if (typeof module === "object" && module.exports) {
    module.exports = factory(require("jquery"));
  } else {
    factory(window.jQuery);
  }
})(function($) {
  $.extend($.summernote.plugins, {
    summernoteAtMention: function(context) {

      /************************
       * Setup instance vars. *
       ************************/
      this.editableEl = context.layoutInfo.editable[0];
      this.editorEl = context.layoutInfo.editor[0];

      this.autocompleteAnchor = { left: null, top: null };
      this.autocompleteContainer = null;
      this.showingAutocomplete = false;
      this.selectedIndex = null;
      this.suggestions = null;

      this.getSuggestions = _ => {
        return [];
      };

      /********************
       * Read-in options. *
       ********************/
      if (
        context.options &&
        context.options.callbacks &&
        context.options.callbacks.summernoteAtMention
      ) {
        const summernoteCallbacks =
          context.options.callbacks.summernoteAtMention;

        if (summernoteCallbacks.getSuggestions) {
          this.getSuggestions = summernoteCallbacks.getSuggestions;
        }

        if (summernoteCallbacks.onSelect) {
          this.onSelect = summernoteCallbacks.onSelect;
        }
      }

      /**********
       * Events *
       **********/
      this.events = {
        "summernote.blur": () => {
          if (this.showingAutocomplete) this.hideAutocomplete();
        },
        "summernote.keydown": (_, event) => {
          if (this.showingAutocomplete) {
            switch (event.keyCode) {
              case ENTER_KEY_CODE: {
                event.preventDefault();
                event.stopPropagation();
                this.handleEnter();
                break;
              }
              case UP_KEY_CODE: {
                event.preventDefault();
                event.stopPropagation();
                const newIndex =
                  this.selectedIndex === 0 ? 0 : this.selectedIndex - 1;
                this.updateAutocomplete(this.suggestions, newIndex);
                break;
              }
              case DOWN_KEY_CODE: {
                event.preventDefault();
                event.stopPropagation();
                const newIndex =
                  this.selectedIndex === this.suggestions.length - 1
                    ? this.selectedIndex
                    : this.selectedIndex + 1;

                this.updateAutocomplete(this.suggestions, newIndex);
                break;
              }
            }
          }
        },
        "summernote.keyup": async (_, event) => {
          const selection = document.getSelection();
          const currentText = selection.anchorNode.nodeValue;
          const { word, absoluteIndex } = this.findWordAndIndices(
            currentText || "",
            selection.anchorOffset
          );
          const trimmedWord = word.slice(1);
          if (
            this.showingAutocomplete &&
            ![DOWN_KEY_CODE, UP_KEY_CODE, ENTER_KEY_CODE].includes(
              event.keyCode
            )
          ) {
            if (word[0] === "@") {
              const suggestions = await this.getSuggestions(trimmedWord);
              this.updateAutocomplete(suggestions, this.selectedIndex);
            } else {
              this.hideAutocomplete();
            }
          } else if (!this.showingAutocomplete && word[0] === "@") {
            this.suggestions = await this.getSuggestions(trimmedWord);
            this.selectedIndex = 0;
            this.showAutocomplete(absoluteIndex, selection.anchorNode);
          }
        }
      };

      /***********
       * Helpers *
       ***********/

      this.handleEnter = () => {
        this.handleSelection();
      };

      this.handleClick = suggestion => {
        const selectedIndex = this.suggestions.findIndex(s => s === suggestion);

        if (selectedIndex === -1) {
          throw new Error("Unable to find suggestion in suggestions.");
        }

        this.selectedIndex = selectedIndex;
        this.handleSelection();
      };

      this.handleSelection = () => {
        if (this.suggestions === null || this.suggestions.length === 0) {
          return;
        }

        const newWord = this.suggestions[this.selectedIndex].trimStart();

        if (this.onSelect !== undefined) {
          this.onSelect(newWord);
        }

        const selection = document.getSelection();
        const currentText = selection.anchorNode.nodeValue;
        const { word, absoluteIndex } = this.findWordAndIndices(
          currentText || "",
          selection.anchorOffset
        );

        const selectionPreserver = new SelectionPreserver(this.editableEl);
        selectionPreserver.preserve();

        selection.anchorNode.textContent =
          currentText.slice(0, absoluteIndex + 1) +
          newWord +
          " " +
          currentText.slice(absoluteIndex + word.length);

        selectionPreserver.restore(absoluteIndex + newWord.length + 1);

        if (context.options.callbacks.onChange !== undefined) {
          context.options.callbacks.onChange(this.editableEl.innerHTML);
        }
      };

      this.updateAutocomplete = (suggestions, selectedIndex) => {
        this.selectedIndex = selectedIndex;
        this.suggestions = suggestions;
        this.renderAutocomplete();
      };

      this.showAutocomplete = (atTextIndex, indexAnchor) => {
        if (this.showingAutocomplete) {
          throw new Error(
            "Cannot call showAutocomplete if autocomplete is already showing."
          );
        }
        this.setAutocompleteAnchor(atTextIndex, indexAnchor);
        this.renderAutocompleteContainer();
        this.renderAutocomplete();
        this.showingAutocomplete = true;
      };

      this.renderAutocompleteContainer = () => {
        this.autocompleteContainer = document.createElement("div");
        this.autocompleteContainer.style.top =
          String(this.autocompleteAnchor.top) + "px";
        this.autocompleteContainer.style.left =
          String(this.autocompleteAnchor.left) + "px";
        this.autocompleteContainer.style.position = "absolute";
        this.autocompleteContainer.style.backgroundColor = "#e4e4e4";
        this.autocompleteContainer.style.zIndex = Number.MAX_SAFE_INTEGER;

        document.body.appendChild(this.autocompleteContainer);
      };

      this.renderAutocomplete = () => {
        if (this.autocompleteContainer === null) {
          throw new Error(
            "Cannot call renderAutocomplete without an autocompleteContainer. "
          );
        }
        const autocompleteContent = document.createElement("div");

        this.suggestions.forEach((suggestion, idx) => {
          const suggestionDiv = document.createElement("div");
          suggestionDiv.textContent = suggestion;

          suggestionDiv.style.padding = "5px 10px";

          if (this.selectedIndex === idx) {
            suggestionDiv.style.backgroundColor = "#2e6da4";
            suggestionDiv.style.color = "white";
          }

          suggestionDiv.addEventListener("mousedown", () => {
            this.handleClick(suggestion);
          });

          autocompleteContent.appendChild(suggestionDiv);
        });

        this.autocompleteContainer.innerHTML = "";
        this.autocompleteContainer.appendChild(autocompleteContent);
      };

      this.hideAutocomplete = () => {
        if (!this.showingAutocomplete)
          throw new Error(
            "Cannot call hideAutocomplete if autocomplete is not showing."
          );

        document.body.removeChild(this.autocompleteContainer);
        this.autocompleteAnchor = { left: null, top: null };
        this.selectedIndex = null;
        this.suggestions = null;
        this.showingAutocomplete = false;
      };

      this.findWordAndIndices = (text, offset) => {
        if (offset > text.length) {
          return { word: "", relativeIndex: 0 };
        } else {
          let leftWord = "";
          let rightWord = "";
          let relativeIndex = 0;
          let absoluteIndex = offset;

          for (let currentOffset = offset; currentOffset > 0; currentOffset--) {
            if (text[currentOffset - 1].match(WORD_REGEX)) {
              leftWord = text[currentOffset - 1] + leftWord;
              relativeIndex++;
              absoluteIndex--;
            } else {
              break;
            }
          }

          for (
            let currentOffset = offset - 1;
            currentOffset > 0 && currentOffset < text.length - 1;
            currentOffset++
          ) {
            if (text[currentOffset + 1].match(WORD_REGEX)) {
              rightWord = rightWord + text[currentOffset + 1];
            } else {
              break;
            }
          }

          return {
            word: leftWord + rightWord,
            relativeIndex,
            absoluteIndex
          };
        }
      };

      this.setAutocompleteAnchor = (atTextIndex, indexAnchor) => {
        let html = indexAnchor.parentNode.innerHTML;
        const text = indexAnchor.nodeValue;

        let atIndex = -1;
        for (let i = 0; i <= atTextIndex; i++) {
          if (text[i] === "@") {
            atIndex++;
          }
        }

        let htmlIndex;
        for (let i = 0, htmlAtIndex = 0; i < html.length; i++) {
          if (html[i] === "@") {
            if (htmlAtIndex === atIndex) {
              htmlIndex = i;
              break;
            } else {
              htmlAtIndex++;
            }
          }
        }

        const atNodeId = "at-node-" + String(Math.floor(Math.random() * 10000));
        const spanString = `<span id="${atNodeId}">@</span>`;

        const selectionPreserver = new SelectionPreserver(this.editableEl);
        selectionPreserver.preserve();

        indexAnchor.parentNode.innerHTML =
          html.slice(0, htmlIndex) + spanString + html.slice(htmlIndex + 1);
        const anchorElement = document.querySelector("#" + atNodeId);
        const anchorBoundingRect = anchorElement.getBoundingClientRect();

        this.autocompleteAnchor = {
          top: anchorBoundingRect.top + anchorBoundingRect.height + 2,
          left: anchorBoundingRect.left
        };

        selectionPreserver.findRangeStartContainer().parentNode.innerHTML = html;
        selectionPreserver.restore();
      };
    }
  });
});
