// This is the html document that forms the little statusbar widget
var canonicalUrlIndicatorDocument = null;

jetpack.statusBar.append({ 
  html: '<div id="canonicalUrlIndicator">P</a>', 
  width: '15px', 
  onReady: function(widget) { 
    // 'Ghost' the permalink icon out by default
    $('#canonicalUrlIndicator', widget).css('color', '#e1e1e1');
    // Keep a reference to the statusbar widget (html document)
    canonicalUrlIndicatorDocument = widget;
    // Call our function when a tab gets focus and when its reloaded
    jetpack.tabs.onReady(showCanonicalUrl);
    jetpack.tabs.onFocus(showCanonicalUrl);
  }
});

var showCanonicalUrl = function() {
  // Get the html content of the document in the current tab
  var doc = jetpack.tabs.focused.contentDocument;
  // Pick out the first link rel=canonical element
  var canonicalLink = $("link[rel='canonical']", doc)[0];
  var canonicalUrlIndicatorWidget = $('#canonicalUrlIndicator', canonicalUrlIndicatorDocument);
  if (canonicalLink) {
    // Make the permalink icon 'active'
    canonicalUrlIndicatorWidget.css('color', '#ff0');
    // Pretty useless at the moment but display a notification if the user clicks on the 'active' permalink icon
    canonicalUrlIndicatorWidget.click(function() {
      jetpack.notifications.show({
        title : 'Canonical Url',
        body : canonicalLink.href
      }); 
    });
  } else {                       
    // If we didn't find a permalink in the page then let's 'ghost' the permalink icon and unregister the click event handler
    canonicalUrlIndicatorWidget.css('color', '#e1e1e1');
    canonicalUrlIndicatorWidget.unbind('click');
  }
}