var httpRequest; // Didn't work as a member of the deliciousTrackbacks object

var deliciousTrackbacks = {
  saveBookMarkAndTrackback : function() {
    this.sendTrackback();
    yAddBookMark.saveBookMark();
  },
  sendTrackback : function() {
    var trackbackUrl = this.findTrackbackUrl();
    if (trackbackUrl) {
      var permalink = this.getPostPermalink();
      if (permalink) {
        var postTitle = document.getElementById('tb_yBookmarkName').value;
        var postNote = document.getElementById("tb_yBookmarkNotes").value;
        this.postTrackback(trackbackUrl, permalink, postTitle, postNote);
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
      // alert('error');
      // alert(e);
    }
  },
  getUsername : function() {
    // Stolen from the onLoad function in yBookmarksOverlay.js of the main del.icio.us extension
    var Y_kDelContractID = "@yahoo.com/socialstore/delicious;1";
    var del = Components.classes[Y_kDelContractID].getService( Components.interfaces.nsISocialStore );
    return del.getUserName();
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
  getPostPermalink : function() {
    try {
      var permalink = 'http://del.icio.us/' + this.getUsername() + '/' + this.getUrlTag();
    } catch(e) {
      // alert(e);
    }
    return permalink;
  },
  postTrackback : function(trackbackUrl, originatingUrl, title, note) {
    try {
      httpRequest = new XMLHttpRequest();
      httpRequest.onload = this.getTrackbackResponse; // Using this instead of onreadystatechange means we don't have to wait for a readyState of 4 (at least that's what I think's happening)
      httpRequest.open("POST", trackbackUrl, true);
      httpRequest.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded')
      httpRequest.send('url=' + encodeURIComponent(originatingUrl) + '&title=' + encodeURIComponent(title) + '&excerpt=' + encodeURIComponent(note));
    } catch(e) {
      // alert('error');
      // alert(e);
    }
  },
  getTrackbackResponse : function() {
    try {
      // alert(httpRequest.status);
      // alert(httpRequest.responseText);
    } catch(e) {
      // alert('error in response');
      // alert(e);
    }
  }
}