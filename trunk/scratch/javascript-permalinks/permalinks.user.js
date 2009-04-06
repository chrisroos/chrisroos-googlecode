// TODO
// * Deal with multiple keys.
// * Actually write the permalink element into the page.
// * Deal with multiple rules.

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
      var keys_and_values = new Url(this.location.href).queryString();

      // Generate the permalink
      var url = this.location;
      if (keys_and_values && keys_and_values[rule.key]) {
        var queryString = [rule.key, keys_and_values[rule.key]].join('=')
        var permalink = url.protocol + '//' + url.host + url.pathname + '?' + queryString;
      }
    }
  }
  
  return permalink;
}

Permalink.rules = [];
Permalink.rules.push({'urlPattern' : /google\.co\.uk\/search/, 'key' : 'q'});
Permalink.rules.push({'urlPattern' : /theyworkforyou\.com\/wrans/, 'key' : 'id'});

var permalink = new Permalink(document.location);
var canonicalLink = document.createElement('link');
canonicalLink.setAttribute('rel', 'canonical');
canonicalLink.setAttribute('href', permalink.href());
var head = document.getElementsByTagName('head')[0];
head.appendChild(canonicalLink);