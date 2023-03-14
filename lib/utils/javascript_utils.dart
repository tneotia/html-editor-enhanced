
class JavascriptUtils {

  static const String jsHandleInsertSignature = '''
    const nodeSignature = document.getElementsByClassName('tmail-signature');
    if (nodeSignature.length <= 0) {
      const nodeEditor = document.getElementsByClassName('note-editable')[0];
      
      const divSignature = document.createElement('div');
      divSignature.setAttribute('class', 'tmail-signature');
      divSignature.innerHTML = data['signature'];
      
      const listHeaderQuotedMessage = nodeEditor.querySelectorAll('cite');
      const listQuotedMessage = nodeEditor.querySelectorAll('blockquote');
      
      if (listHeaderQuotedMessage.length > 0) {
        nodeEditor.insertBefore(divSignature, listHeaderQuotedMessage[0]);
      } else if (listQuotedMessage.length > 0) {
        nodeEditor.insertBefore(divSignature, listQuotedMessage[0]);
      } else {
        nodeEditor.appendChild(divSignature);
      }
    } else {
      nodeSignature[0].innerHTML = data['signature'];
    }
  ''';

  static const String jsHandleRemoveSignature = '''
    const nodeSignature = document.getElementsByClassName('tmail-signature');
    if (nodeSignature.length > 0) {
      nodeSignature[0].remove();
    }
  ''';
}