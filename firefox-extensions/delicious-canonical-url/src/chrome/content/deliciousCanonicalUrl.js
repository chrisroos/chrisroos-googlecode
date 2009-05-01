var deliciousCanonicalUrl = {
  
  updateBookmarkUrl : function() {
    var documentOfOpeningWindow = window.opener.content.document;
    var head = documentOfOpeningWindow.getElementsByTagName('head')[0];

    var canonicalUrl = this.findCanonicalUrl(head);
    if (canonicalUrl) {
      document.getElementById('lbl_yBookmarkURL').value = canonicalUrl + ' (CANONICAL)'; // The url in the textbox is used so I'm OK to update this
      document.getElementById('tb_yBookmarkURL').value = canonicalUrl;
    }
  },
  
  findCanonicalUrl : function(htmlContainer) {
    var linkElements = htmlContainer.getElementsByTagName('link');
    for (var i = 0; i < linkElements.length; i++) {
      if (linkElements[i].getAttribute('rel') == 'canonical')
        return linkElements[i].getAttribute('href');
    }
  }
  
}