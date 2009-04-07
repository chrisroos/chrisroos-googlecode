// TODO: Deal with multiple keys (find an example that actually requires this before implementing though).
// TODO: Find a way to run all javascript tests at once.
// TODO: Think about Permalink.add_rule(name, key_or_callback) type method instead of pushing directly onto the rules array.
// TODO: Think about I can externalise all the rules (maybe GM_xmlhttpRequest will help?)
// TODO: Should I be returning empty strings (or undefined) when permalinks cannot be generated?
// TODO: Create a rule object (which has url and callback).
// TODO: Rename modifier to something more useful (apply, for example).
// TODO: Investigate requiring other files from the extension, that way I could have a rule per file that just get required.
// TODO: Add metadata

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