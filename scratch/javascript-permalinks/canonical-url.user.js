// ==UserScript==
// @name          Canonical Url Generation and Insertion
// @namespace     http://chrisroos.co.uk/
// @description   A script that allows me to construct rules to determine the permalink of a given URL and write that permalink into the page as a link element with rel=canonical.
// @include       *
// ==/UserScript==

CanonicalUrl = {}

CanonicalUrl.Url = function(location) {
  this.hash = location.hash;
  this.host = location.host;
  this.hostname = location.hostname;
  this.href = location.href;
  this.pathname = location.pathname;
  this.port = location.port;
  this.protocol = location.protocol;
  this.search = location.search;
  this._queryString = function() {
    var keysAndValues = {};
    if (m = this.href.match(/\?(.*)/)) {
      var queryString = m[1];
      var keyValuePairs = queryString.split('&');
      if (keyValuePairs.length > 0) {
        for (var i = 0; i < keyValuePairs.length; i++) {
          var key = keyValuePairs[i].split('=')[0];
          var value = keyValuePairs[i].split('=')[1];
          if (key)
            keysAndValues[key] = value;
        }
      }
    }
    return keysAndValues;
  };
  this.queryString = this._queryString();
}

CanonicalUrl.Permalink = function(location) {
  this.location = location;
}
CanonicalUrl.Permalink.prototype.href = function() {
  var permalink = '';
  for (var i = 0; i < CanonicalUrl.Rules.length; i++) {
    var rule = CanonicalUrl.Rules[i];
    if (rule.urlPattern.test(this.location.href)) {
      if (rule.modifier && typeof(rule.modifier) == 'function')
        permalink = rule.modifier(new CanonicalUrl.Url(this.location));
    }
  }
  return permalink;
}

CanonicalUrl.requiredKeyRule = function(url, key) {
  if (key && url.queryString && url.queryString[key]) {
    var queryString = [key, url.queryString[key]].join('=');
    return url.protocol + '//' + url.host + url.pathname + '?' + queryString;
  } else {
    return '';
  }
}

CanonicalUrl.Rules = [];
CanonicalUrl.Rules.push({
  'urlPattern' : /userscript_integration_test\.html/, 
  'modifier' : function(url) { 
    return 'userscript-permalink';
  }
});
CanonicalUrl.Rules.push({
  'urlPattern' : /google\.co\.uk\/search/, 
  'modifier' : function(url) { 
    return CanonicalUrl.requiredKeyRule(url, 'q');
  }
});
CanonicalUrl.Rules.push({
  'urlPattern' : /theyworkforyou\.com\/wrans/, 
  'modifier' : function(url) { 
    return CanonicalUrl.requiredKeyRule(url, 'id');
  }
});
CanonicalUrl.Rules.push({
  'urlPattern' : /cgi\.ebay\.co\.uk/,
  'modifier'   : function(url) {
    var hash = url.queryString.hash;
    if (m = hash.match(/item(\d+)/)) {
      var itemId = m[1];
      return 'http://cgi.ebay.co.uk/ws/eBayISAPI.dll?ViewItem&item=' + itemId;
    }
  }
});

CanonicalUrl.CanonicalLink = {
  'write' : function(permalink) {
    if (href = permalink.href()) {
      var canonicalLink = document.createElement('link');
      canonicalLink.setAttribute('rel', 'canonical');
      canonicalLink.setAttribute('href', href);
      var head = document.getElementsByTagName('head')[0];
      head.appendChild(canonicalLink);
    }
  }
}

CanonicalUrl.insert = function(location) {
  var permalink = new CanonicalUrl.Permalink(location);
  CanonicalUrl.CanonicalLink.write(permalink);
}

CanonicalUrl.insert(document.location);