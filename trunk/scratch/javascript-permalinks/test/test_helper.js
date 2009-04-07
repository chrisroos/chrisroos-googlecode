TestHelper = {  
  getCanonicalLinkElements: function() {
    var head = document.getElementsByTagName('head')[0];
    var linkElements = head.getElementsByTagName('link');
    var canonicalLinkElements = [];
    for (var i = 0; i < linkElements.length; i++) {
      if (linkElements[i].getAttribute('rel') == 'canonical') {
        canonicalLinkElements.push(linkElements[i]);
      }
    }
    return canonicalLinkElements;
  }
}