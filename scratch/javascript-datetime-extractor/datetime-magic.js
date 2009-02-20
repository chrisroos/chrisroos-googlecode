var months = {
  1 : 'Jan',  2 : 'Feb',  3 : 'Mar',
  4 : 'Apr',  5 : 'May',  6 : 'Jun',
  7 : 'Jul',  8 : 'Aug',  9 : 'Sep',
  10 : 'Oct', 11 : 'Nov', 12 : 'Dec'
}
var datetimeRegexp = /(\d{4})-(\d{2})-(\d{2})/; // Example datetime : 2005-03-08T04:38:12

function printDate(m) {
  var day = parseInt(m[3], 10); // Explicitly base 10 otherwise 01 (for example) will be parsed as octal
  var month = months[parseInt(m[2], 10)]; // Explicitly base 10 otherwise 01 (for example) will be parsed as octal
  var year = m[1];
  var humanDate = day + ' ' + month + ' ' + year
  console.log('Posted: ' + humanDate);
}

// Search for microformats datetime design pattern first (http://microformats.org/wiki/datetime-design-pattern)
var abbrTags = document.getElementsByTagName('abbr');
for (var i=0; i < abbrTags.length; i++) {
  var abbrTitle = abbrTags[i].getAttribute('title')
  if (m = abbrTitle.match(datetimeRegexp)) {
    printDate(m);
  }
}

// Search the whole document for something that looks like a date
var html = document.body.innerHTML;
if (m = html.match(datetimeRegexp)) {
  printDate(m);
}