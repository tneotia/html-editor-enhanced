class SelectionPreserver {
  constructor(rootNode) {
    if (rootNode === undefined || rootNode === null) {
      throw new Error("Please provide a valid rootNode.");
    }

    this.rootNode = rootNode;
    this.rangeStartContainerAddress = null;
    this.rangeStartOffset = null;
  }

  preserve() {
    const selection = window.getSelection();
    this.rangeStartOffset = selection.getRangeAt(0).startOffset;
    this.rangeStartContainerAddress = this.findRangeStartContainerAddress(
      selection
    );
  }

  restore(restoreIndex) {
    if (
      this.rangeStartOffset === null ||
      this.rangeStartContainerAddress === null
    ) {
      throw new Error("Please call preserve() first.");
    }

    let rangeStartContainer = this.findRangeStartContainer();

    const range = document.createRange();
    const offSet = restoreIndex || this.rangeStartOffset;
    range.setStart(rangeStartContainer, offSet);
    range.collapse();

    const selection = window.getSelection();
    selection.removeAllRanges();
    selection.addRange(range);
  }

  findRangeStartContainer() {
    let rangeStartContainer = this.rootNode;

    this.rangeStartContainerAddress.forEach(address => {
      rangeStartContainer = rangeStartContainer.childNodes[address];
    });

    return rangeStartContainer;
  }

  findRangeStartContainerAddress(selection) {
    let rangeStartContainerAddress = [];

    for (
      let currentContainer = selection.getRangeAt(0).startContainer;
      currentContainer !== this.rootNode;
      currentContainer = currentContainer.parentNode
    ) {
      const parent = currentContainer.parentElement;
      const children = parent.childNodes;

      for (let i = 0; i < children.length; i++) {
        if (children[i] === currentContainer) {
          rangeStartContainerAddress = [i, ...rangeStartContainerAddress];
          break;
        }
      }
    }
    return rangeStartContainerAddress;
  }
}

const WORD_REGEX = /^[^\s]+$/;

const UP_KEY_CODE = 38;
const DOWN_KEY_CODE = 40;
const ENTER_KEY_CODE = 13;

