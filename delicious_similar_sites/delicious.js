// Execute this within an existing webpage, using, for example, firebug console
function includeDelicious() {
  function loadScript(scriptUrl) {
    var scriptTag = document.createElement('script');
    scriptTag.setAttribute('type', 'text/javascript');
    scriptTag.src = scriptUrl;
    document.body.appendChild(scriptTag);
  }
  loadScript('http://s3.amazonaws.com/seagul/delicious.js');
}
if (typeof(getRelatedPosts) != 'function') { includeDelicious(); }

// This stuff is the 'server-side' stuff
function loadScript(scriptUrl) {
  var scriptTag = document.createElement('script');
  scriptTag.setAttribute('type', 'text/javascript');
  scriptTag.src = scriptUrl;
  document.body.appendChild(scriptTag);
}
loadScript('http://s3.amazonaws.com/seagul/md5.js');
loadScript('http://s3.amazonaws.com/seagul/jquery.js');

function getRelatedPosts() {
  var postsDiv = document.createElement('div');
  postsDiv.id = 'posts';
  document.body.appendChild(postsDiv);
  
  var url = document.location.href;
  var urlHash = hex_md5(url);

  var deliciousUrl = 'http://badges.del.icio.us/feeds/json/url/data?hash=' + urlHash + '&callback=?';
  $.getJSON(deliciousUrl, function(data){
    if (data.length > 0) {
      var topTags = data[0].top_tags;
      for (var tag in topTags) {
        var tagUrl = 'http://del.icio.us/feeds/json/chrisjroos/' + tag + '?count=3&callback=?'
        $.getJSON(tagUrl, function(data){
          // when this callback gets called, tag will either be set to something else or undefined.  luckily, the del.icio.us
          // url contains the tag, so we just need a bit of regex magic to extract it
          var tag = this.url.match(/chrisjroos\/(.+)\?/)[1];
          $('div#posts').append('<h2>' + tag + '</h2>')
          $('div#posts').append('<ul>')
          $.each(data, function(i, post) {
            var postHtml = '<li>';
            var postHtml = postHtml + '<a href="' + post.u + '">' + post.d + '</a> - ';
            var postHtml = postHtml + '<span class="description">' + post.n + '</span>';
            var postHtml = postHtml + '</li>';
            $('div#posts').append(postHtml);
          });
        });
        $('div#posts').append('</ul>')
      }
    }
  });
};

setTimeout(getRelatedPosts, 1000);