var deliciousPermalinks = {
  addPermalinkTag : function() {
    var post = window.arguments[0];
    var urlTag = hex_md5(post.url);
    if (!this.tagExists(urlTag, post.tags)) {
      post.tags.push(urlTag);
      yAddBookMark._addToUserTags(urlTag);
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