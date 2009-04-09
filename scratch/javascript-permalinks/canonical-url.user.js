// ==UserScript==
// @name          Canonical Url Generation and Insertion
// @namespace     http://chrisroos.co.uk/
// @description   A script that allows me to construct rules to determine the permalink of a given URL and write that permalink into the page as a link element with rel=canonical.
// @include       *
// ==/UserScript==

CanonicalUrl = {}

// **********************************************
// CanonicalUrl members

CanonicalUrl.queryString = function(location) {
  var keysAndValues = {};
  if (m = location.href.match(/\?(.*)/)) {
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
}

CanonicalUrl.Url = function(location) {
  this.hash = location.hash;
  this.host = location.host;
  this.hostname = location.hostname;
  this.href = location.href;
  this.pathname = location.pathname;
  this.port = location.port;
  this.protocol = location.protocol;
  this.search = location.search;
  this.queryString = CanonicalUrl.queryString(location);
}

CanonicalUrl.Permalink = function(location) {
  this.location = location;
}

CanonicalUrl.requiredKeyRule = function(url, key) {
  if (key && url.queryString && url.queryString[key]) {
    var queryString = [key, url.queryString[key]].join('=');
    return url.protocol + '//' + url.host + url.pathname + '?' + queryString;
  } else {
    return '';
  }
}

CanonicalUrl.Rule = function(urlPattern, modifier) {
  this.urlPattern = urlPattern;
  this.modifier = modifier;
};

CanonicalUrl.RuleCollection = function() {
  this.rules = [];
}

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

// **********************************************
// CanonicalUrl member prototypes

CanonicalUrl.Permalink.prototype.href = function() {
  var permalink = CanonicalUrl.Rules.apply(this.location);
  if (!permalink) { permalink = ''; }
  return permalink;
}

CanonicalUrl.RuleCollection.prototype.add = function(urlPattern, modifier) {
  var rule = new CanonicalUrl.Rule(urlPattern, modifier);
  this.rules.push(rule);
};

CanonicalUrl.RuleCollection.prototype.apply = function(location) {
  for (var i = 0; i < this.rules.length; i++) {
    var rule = this.rules[i];
    if (rule.urlPattern.test(location.href)) {
      if (rule.modifier && typeof(rule.modifier) == 'function')
        return rule.modifier(new CanonicalUrl.Url(location));
    }
  }
}

// **********************************************
// The actual real-life rules

CanonicalUrl.Rules = new CanonicalUrl.RuleCollection();
CanonicalUrl.Rules.add(/userscript_integration_test\.html/, function(url) { 
  return 'userscript-permalink';
});
CanonicalUrl.Rules.add(/google\.co\.uk\/search/, function(url) { 
  return CanonicalUrl.requiredKeyRule(url, 'q');
});
CanonicalUrl.Rules.add(/theyworkforyou\.com\/wrans/, function(url) { 
  return CanonicalUrl.requiredKeyRule(url, 'id');
});
CanonicalUrl.Rules.add(/cgi\.ebay\.co\.uk/, function(url) {
  var hash = url.queryString.hash;
  if (m = hash.match(/item(\d+)/)) {
    var itemId = m[1];
    return 'http://cgi.ebay.co.uk/ws/eBayISAPI.dll?ViewItem&item=' + itemId;
  }
});

// **********************************************
// Do the magic
CanonicalUrl.insert(document.location);