var httpRequest; // Didn't work as a member of the deliciousTrackbacks object

var deliciousTrackbacks = {
  sendTrackback : function() {
    var trackbackUrl = this.findTrackbackUrl();
    if (trackbackUrl) {
      var permalink = this.getUrlTag();
      if (permalink) {
        this.postTrackback(trackbackUrl, permalink);
      };
    };
  },
  findTrackbackUrl : function() {
    try {
      var mainWindow = window.opener;
      var browser = mainWindow.getBrowser();
      var webNav = browser.webNavigation;
      var htmlDocument = webNav.document;
      var trackbackAnchor = htmlDocument.evaluate('//a[@rel="trackback"]', htmlDocument, null, XPathResult.ANY_TYPE, null).iterateNext()
      return trackbackAnchor;
    } catch(e) {
      alert('error');
      alert(e);
    }
  },
  getUrlTag : function() {
    var post = window.arguments[0];
    var urlTagRegex = /^url\/.+/;
    for (var i = 0; i < post.tags.length; ++i) {
      var tag = post.tags[i];
      if (urlTagRegex.test(tag)) {
        return tag;
      }
    }
  },
  postTrackback : function(trackbackUrl, originatingUrl) {
    try {
      httpRequest = new XMLHttpRequest();
      httpRequest.onload = this.getTrackbackResponse; // Using this instead of onreadystatechange means we don't have to wait for a readyState of 4 (at least that's what I think's happening)
      httpRequest.open("POST", trackbackUrl, true);
      httpRequest.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded')
      httpRequest.send('url=' + originatingUrl);
    } catch(e) {
      alert('error');
      alert(e);
    }
  },
  getTrackbackResponse : function() {
    try {
      alert(httpRequest.status);
      alert(httpRequest.responseText);
    } catch(e) {
      alert('error in response');
      alert(e);
    }
  }
}