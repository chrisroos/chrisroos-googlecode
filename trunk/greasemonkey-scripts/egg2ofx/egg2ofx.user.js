// ==UserScript==
// @name          Egg to Ofx
// @namespace     http://chrisroos.co.uk/
// @description   Adds a button to the Egg statement and recent transactions pages that allows you to download them as Ofx.
// @include       *egg.local*
// @include       *egg.com*
// ==/UserScript==

(function() {
  try {
    
    var egg2ofxService = 'http://egg2ofx.local/';
    var transactionsTable;
    
    if (transactionsTable = document.getElementById('tblTransactionsTable')) {
      var f = document.createElement('form');
      f.setAttribute('id', 'convertToOfxForm');
      f.setAttribute('method', 'POST');
      f.setAttribute('action', egg2ofxService);
    
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
      
      transactionsTable.parentNode.insertBefore(f, transactionsTable);
    }
  } catch(e) {
    console.log('egg2ofx.user.js error');
    console.log(e);
  }
})()