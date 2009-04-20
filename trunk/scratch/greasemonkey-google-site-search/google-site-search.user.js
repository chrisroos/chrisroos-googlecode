// ==UserScript==
// @name          Google site search
// @namespace     http://chrisroos.co.uk/
// @description   Insert a 'google site search' search form to every page.
// @include       *
// @exclude       http://www.google.co.uk*
// @exclude       http://www.google.com*
// ==/UserScript==

(function() {
  // Create an array of 'sites' (either the domain or domain + paths) that the user can use to search google with
  var sites = [window.location.host];
  if (window.location.pathname != '/') {
    // pathComponentsTemp will contain empty elements.  We iterate over this and populate pathComponents with just the non-empty elements
    var pathComponentsTemp = window.location.pathname.split('/');
    var pathComponents = [];
    for (var pathComponentIndex = 0; pathComponentIndex < pathComponentsTemp.length; pathComponentIndex++) {
      if (pathComponentsTemp[pathComponentIndex]) {
        pathComponents.push(pathComponentsTemp[pathComponentIndex]);
      }
    }
    // We can't use pathComponents.length in the for (...) statement because it changes as we pop() elements
    var pathComponentCount = pathComponents.length;
    for (var pathComponentIndex = 0; pathComponentIndex < pathComponentCount; pathComponentIndex++) {
      sites.push(window.location.host + '/' + pathComponents.join('/'));
      pathComponents.pop();
    }
  }
  
  var sitesSelect = document.createElement('select');
  sitesSelect.setAttribute('name', 'q');
  sitesSelect.setAttribute('style', 'margin-left: 5px;');
  sitesSelect.addEventListener('keypress', function(event) {
    if (event.keyCode == 13)
      document.getElementById('greasemonkey-google-site-search-form').submit();
  }, true);
  sites.sort(); // This should result in a list of sites ordered by length
  for (var i = 0; i < sites.length; i++) {
    var site = sites[i];
    var sitesOption = document.createElement('option');
    sitesOption.setAttribute('value', 'site:' + site);
    sitesOption.appendChild(document.createTextNode(site));
    sitesSelect.appendChild(sitesOption);
  }

  var s2 = document.createElement('input');
  s2.setAttribute('type', 'text');
  s2.setAttribute('name', 'q');
  s2.setAttribute('accesskey', '9');
  s2.setAttribute('style', 'margin-left: 5px;');

  var s3 = document.createElement('input');
  s3.setAttribute('type', 'submit');
  s3.setAttribute('name', 'sa'); // Is this name important?
  s3.setAttribute('value', 'google site search');
  s3.setAttribute('style', 'margin-left: 5px;');

  var f = document.createElement('form');
  f.setAttribute('id', 'greasemonkey-google-site-search-form')
  f.setAttribute('action', 'http://www.google.co.uk/search');

  f.appendChild(s2);
  f.appendChild(sitesSelect);
  f.appendChild(s3);

  var d = document.createElement('div');
  d.setAttribute('style', 'width: 99%; padding: 5px; text-align: right');

  d.appendChild(f);

  document.body.insertBefore(d, document.body.firstChild);
})()