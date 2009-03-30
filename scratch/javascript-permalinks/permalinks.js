// TODO
// * Deal with multiple keys

// The rule
var urlRegex = /http:\/\/localhost/
var wanted_key = 'id';

if (urlRegex.test(document.location.href)) {

  // Parse the querystring
  var url = document.location;
  var queryString = url.search.replace(/^\?/, ''); // Remove leading question mark
  var key_value_pairs = queryString.split('&');
  if (key_value_pairs.length > 0 && key_value_pairs[0] != '') {
    var keys_and_values = {};
    for (var i = 0; i < key_value_pairs.length; i++) {
      var key = key_value_pairs[i].split('=')[0];
      var value = key_value_pairs[i].split('=')[1];
      keys_and_values[key] = value;
    }
  }
  
  // Generate the permalink
  if (keys_and_values && keys_and_values[wanted_key]) {
    var queryString = [wanted_key, keys_and_values[wanted_key]].join('=')
    var permalink = url.protocol + '//' + url.host + url.pathname + '?' + queryString;
    console.log('Permalink for ' + url + ' is ' + permalink);
    // document.location.replace(permalink);
  } else {
    console.log('Permalink could not be generated for ' + url);
  }
}