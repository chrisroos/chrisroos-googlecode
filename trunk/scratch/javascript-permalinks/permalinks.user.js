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

function Permalink(location, rule) {
  this.location = location;
  this.rule = rule;
}
Permalink.prototype.href = function() {
  var urlRegex = this.rule.urlPattern;
  var wanted_key = this.rule.key;
  var permalink = '';
  
  if (urlRegex.test(this.location.href)) {
    // Parse the querystring
    var keys_and_values = new Url(this.location.href).queryString();

    // Generate the permalink
    var url = this.location;
    if (keys_and_values && keys_and_values[wanted_key]) {
      var queryString = [wanted_key, keys_and_values[wanted_key]].join('=')
      var permalink = url.protocol + '//' + url.host + url.pathname + '?' + queryString;
    }
  }
  
  return permalink;
}