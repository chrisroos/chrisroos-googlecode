var docTypes = {
  'html-4-strict' : '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">',
  'html-4-loose' : '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">',
  'html-4-frameset' : '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN" "http://www.w3.org/TR/html4/frameset.dtd">',
  'xhtml-1-strict' : '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">',
  'xhtml-1-transitional' : '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">',
  'xhtml-1-frameset' : '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Frameset//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-frameset.dtd">',
  'xhtml-1-1' : '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">'
}

function generateHtml(doctype, body) {
  var html = '';
  if (typeof(doctype) != 'undefined') { html += doctype + '\n'; }
  html += '<html>\n';
  html += '  <head>\n';
  html += '    <title>dynamically generated html</title>\n';
  html += '  </head>\n';
  html += '  <body>\n';
  if (typeof(body) != 'undefind') { html += body + '\n'; }
  html += '  </body>\n';
  html += '</html>\n';
  return html;
}

function getDoctypeInputs() {
  return parent.generator.document.getElementsByTagName('input')
}

function getDoctype() {
  var doctypes = getDoctypeInputs()
  for (var i = 0; i < doctypes.length; i++) { 
    if (doctypes[i].checked == true) {
    var doctype = doctypes[i].value;
      return docTypes[doctype];
    }
  }
}

function getBody() {
  return document.getElementById('htmlBody').value;
}

function showHtml() {
  var htmlDocument = generateHtml(getDoctype(), getBody());
  updateHtmlPreview(htmlDocument);
  updateHtmlDocument(htmlDocument);
}

function updateHtmlDocument(html) {
  var d = parent.blank.document;
  d.open();
  d.write(html);
  d.close();
}

function updateHtmlPreview(html) {
  var preview = document.getElementById('htmlPreview');
  preview.innerHTML = html;
}

function attachEvents() {
  var doctypes = getDoctypeInputs()
  for (var i = 0; i < doctypes.length; i++) {
    var doctype = doctypes[i];
    doctype.onclick=showHtml;
  }
  var htmlBodyTextArea = document.getElementById('htmlBody');
  htmlBodyTextArea.onkeyup=showHtml;
}

function init() {
  showHtml();
  attachEvents();
}
