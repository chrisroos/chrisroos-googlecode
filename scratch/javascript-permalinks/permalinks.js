// The rule
var urlRegex = /http:\/\/www.theyworkforyou.com\/wrans/
var wanted_keys = 'id';

if (urlRegex.test(document.location.href)) {

  // Parse the querystring
  var url = document.location;
  var queryString = url.search.replace(/^\?/, ''); // Remove leading question mark
  var key_value_pairs = queryString.split('&');
  var keys_and_values;
  for (var i = 0; i < key_value_pairs.length; i++) {
    var key = key_value_pairs[i].split('=')[0];
    var value = key_value_pairs[i].split('=')[1];
    keys_and_values[key] = value;
  }
  
  // Generate the permalink
  var permalink = url.protocol + '//' + url.host + url.pathname + '?id=' + keys_and_values.id;
  document.location.replace(permalink);

}