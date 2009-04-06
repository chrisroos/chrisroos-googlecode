// TODO: Deal with multiple keys (find an example that actually requires this before implementing though).
// TODO: Only write the canonical link tag if a permalink is returned.
// TODO: Check that the modifier callback is a function.

function Url(url) {
  this.url = url;
}
Url.prototype.queryString = function() {
  var keysAndValues = {};
  if (m = this.url.match(/\?(.*)/)) {
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

function Permalink(location) {
  this.location = location;
}
Permalink.prototype.href = function() {
  var permalink = '';

  for (var i = 0; i < Permalink.rules.length; i++) {
    var rule = Permalink.rules[i];
    if (rule.urlPattern.test(this.location.href)) {
      // Parse the querystring
      var keysAndValues = new Url(this.location.href).queryString();

      // Generate the permalink
      var url = this.location;
      if (rule.key && keysAndValues && keysAndValues[rule.key]) {
        var queryString = [rule.key, keysAndValues[rule.key]].join('=')
        permalink = url.protocol + '//' + url.host + url.pathname + '?' + queryString;
      } else if (rule.modifier) {
        permalink = rule.modifier(url.href);
      }
    }
  }
  
  return permalink;
}

Permalink.rules = [];
Permalink.rules.push({'urlPattern' : /google\.co\.uk\/search/, 'key' : 'q'});
Permalink.rules.push({'urlPattern' : /theyworkforyou\.com\/wrans/, 'key' : 'id'});
var ebayRule = {
  'urlPattern' : /cgi\.ebay\.co\.uk/,
  'modifier'   : function(url) {
    var queryString = new Url(url).queryString();
    var hash = queryString.hash;
    if (m = hash.match(/item(\d+)/)) {
      var itemId = m[1];
      return 'http://cgi.ebay.co.uk/ws/eBayISAPI.dll?ViewItem&item=' + itemId;
    }
  }
}
Permalink.rules.push(ebayRule);

CanonicalLink = {
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

var permalink = new Permalink(document.location);
CanonicalLink.write(permalink);