window.addEventListener("load", function() { myExtension.init(); }, false);

var myExtension = {
  init: function() {
    var appcontent = document.getElementById("appcontent");   // browser
    if(appcontent)
      appcontent.addEventListener("DOMContentLoaded", this.onPageLoad, true);
  },

  onPageLoad: function(aEvent) {
    var doc = aEvent.originalTarget; // doc is document that triggered "onload" event
    var url = doc.location.href;
    openDeliciousUrl(url);
  }
}