var deliciousDomainTags = {
  addDomainTag : function() {
    var post = window.arguments[0];
    var domainTag = post.url.match(/:\/\/([^\/]+)/)[1];
    domainTag = domainTag.replace(/^www\./, ''); // Remove the www prefix if present
    if (!this.tagExists(domainTag, post.tags)) {
      post.tags.push(domainTag);
      yAddBookMark._addToUserTags(domainTag);
    }
  },
  tagExists : function(tag, tags) {
    for (var i = 0; i < tags.length; ++i) {
      if (tag == tags[i]) {
        return true;
      }
    }
    return false;
  }
}