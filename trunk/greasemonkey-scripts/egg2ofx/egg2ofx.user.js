// ==UserScript==
// @name          Egg to Ofx
// @namespace     http://chrisroos.co.uk/
// @description   Adds a button to the Egg statement page that allows you to convert the statement to Ofx.
// @include       *egg.local*
// @include       *egg.com*
// ==/UserScript==

(function() {
  try {
    var f = document.createElement('form');
    f.setAttribute('id', 'convertToOfxForm');
    f.setAttribute('method', 'POST');
    f.setAttribute('action', 'http://egg2ofx.local/');
    
    var b = document.createElement('input');
    b.setAttribute('type', 'button');
    b.setAttribute('value', 'Download as OFX');
    var convertToOfxFormSubmitFunction = function() { 
      var h = document.createElement('input');
      h.setAttribute('type', 'hidden');
      h.setAttribute('name', 'documentHtml');
      h.setAttribute('value', document.body.innerHTML);
      var f = document.getElementById('convertToOfxForm')
      f.appendChild(h);
      f.submit();
    }
    b.addEventListener('click', convertToOfxFormSubmitFunction, true);
    
    f.appendChild(b);
  
    var transactionsTable = document.getElementById('tblTransactionsTable');
    transactionsTable.parentNode.insertBefore(f, transactionsTable);
  } catch(e) {
    console.log('error');
    console.log(e);
  }
})()