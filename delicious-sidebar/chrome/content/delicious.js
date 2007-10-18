function openDeliciousUrl(url) {
  var browser = document.getElementById('sidebar').contentDocument.getElementById('browserid');
  var urlHash = hex_md5(url);
  var deliciousUrl = 'http://del.icio.us/url/' + urlHash
  browser.webNavigation.loadURI(deliciousUrl, Components.interfaces.nsIWebNavigation.LOAD_FLAGS_NONE, null, null, null);
};