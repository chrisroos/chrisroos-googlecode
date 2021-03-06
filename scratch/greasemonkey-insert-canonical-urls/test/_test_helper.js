TestHelper = {  
  
  getLinkElements: function() {
    var head = document.getElementsByTagName('head')[0];
    return head.getElementsByTagName('link');
  },
  
  getCanonicalLinkElements: function() {
    var linkElements = TestHelper.getLinkElements();
    var canonicalLinkElements = [];
    for (var i = 0; i < linkElements.length; i++) {
      if (linkElements[i].getAttribute('rel') == 'canonical') {
        canonicalLinkElements.push(linkElements[i]);
      }
    }
    return canonicalLinkElements;
  },
  
  removeCanonicalLinkElements: function() {
    var linkElements = TestHelper.getLinkElements();
    for (var i = 0; i < linkElements.length; i++) {
      if (linkElements[i].getAttribute('rel') == 'canonical') {
        linkElements[i].parentNode.removeChild(linkElements[i]);
      }
    }
  },
  
  insertCanonicalUrlUserScript: function() {
    var scriptElement = document.createElement('script');
    scriptElement.setAttribute('src', '../src/canonical-url.user.js');
    scriptElement.setAttribute('type', 'text/javascript');
    document.body.appendChild(scriptElement);
  }
  
}