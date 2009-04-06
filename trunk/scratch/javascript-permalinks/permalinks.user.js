// TODO
// * Deal with multiple keys.
// * It'd be good to be able to supply callbacks instead of simply extracting a key from the querystring.  This would allow me to construct a permalink for ebay auctions.  Turning something like:
// ** http://cgi.ebay.co.uk/Netgear-RangeMax-WPN824-MIMO-Wireless-Router-108MBPS_W0QQitemZ120398909420QQcmdZViewItemQQptZUK_Computing_Networking_SM?hash=item120398909420&_trksid=p3286.c0.m14&_trkparms=72%3A1690|66%3A2|65%3A12|39%3A1|240%3A1308
// into
// ** http://cgi.ebay.co.uk/ws/eBayISAPI.dll?ViewItem&item=120398909420

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