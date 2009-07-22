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
    jetpack.tabs.onReady(highlightWidget);
    jetpack.tabs.onFocus(highlightWidget);
    // Add the click event to the widget that displays the canonical url if it exists
    $(widget).click(displayCanonicalUrl);
  }
});

var findCanonicalUrl = function() {
  // Get the html content of the document in the current tab
  var doc = jetpack.tabs.focused.contentDocument;
  // Pick out the first link rel=canonical element
  return $("link[rel='canonical']", doc)[0];
}

var highlightWidget = function() {
  var canonicalUrlIndicatorWidget = $('#canonicalUrlIndicator', canonicalUrlIndicatorDocument);
  var canonicalLink = findCanonicalUrl();
  if (canonicalLink) {
    // Make the permalink icon 'active'
    canonicalUrlIndicatorWidget.css('color', '#ff0');
  } else {                       
    // If we didn't find a permalink in the page then let's 'ghost' the permalink icon
    canonicalUrlIndicatorWidget.css('color', '#e1e1e1');
  }
}

var displayCanonicalUrl = function() {
  var canonicalLink = findCanonicalUrl();
  if (canonicalLink) {
    jetpack.notifications.show({
      title : 'Canonical Url',
      body : canonicalLink.href
    });
  }
}