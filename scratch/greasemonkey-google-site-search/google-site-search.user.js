// ==UserScript==
// @name          Google site search
// @namespace     http://chrisroos.co.uk/
// @description   Insert a 'google site search' search form to every page.
// @include       *
// @exclude       google.co.uk
// @exclude       google.com
// ==/UserScript==

(function() {
  var s1 = document.createElement('input');
  s1.setAttribute('type', 'hidden');
  s1.setAttribute('name', 'q');
  s1.setAttribute('value', 'site:' + window.location.host); // insert the domain of the site we're visiting here

  var s2 = document.createElement('input');
  s2.setAttribute('type', 'text');
  s2.setAttribute('name', 'q');
  s2.setAttribute('accesskey', '9');

  var s3 = document.createElement('input');
  s3.setAttribute('type', 'submit');
  s3.setAttribute('name', 'sa'); // Is this name important?
  s3.setAttribute('value', 'search');

  var f = document.createElement('form');
  f.setAttribute('action', 'http://www.google.co.uk/search');

  f.appendChild(s1);
  f.appendChild(s2);
  f.appendChild(s3);

  var d = document.createElement('div');
  d.setAttribute('style', 'width: 100%; padding: 5px; text-align: right');

  d.appendChild(f);

  document.body.insertBefore(d, document.body.firstChild);
})()