require File.join(File.dirname(__FILE__), '..', 'config', 'environment')
require 'article'

attributes = {
  :title => "Tagging my del.icio.us bookmarks with the domain of the URL that I'm bookmarking",
  :body => DATA.read,
  :guid => '0965ddb3-1309-4dc8-a04f-297cf892aa75',
  :published_at => Time.parse('2008-02-26 08:49:00')
}

if Article.find_by_title(attributes[:title])
  p 'Article already exists, skipping'
else
  Article.create!(attributes)
  p 'Article created'
end

__END__
I've created another "firefox":www.mozilla.com/firefox extension that builds on the "del.icio.us":http://del.icio.us "extension":https://addons.mozilla.org/en-US/firefox/addon/3615.  This one finds the domain of the "URL":http://en.wikipedia.org/wiki/Uniform_Resource_Locator you're bookmarking and adds it as a tag to your bookmark.  It's basically just a copy of my "del.icio.us permalinks extension":http://blog.seagul.co.uk/articles/2007/12/18/extracting-my-del-icio-us-permalinks-functionality-into-its-own-firefox-extension

I came across an interesting problem when trying to get both this and the del.icio.us permalinks extension working together.  Both of the extensions modify the onload attribute of the add bookmark dialog.  When I only had the del.icio.us permalinks extension I was hardcoding the onload attribute to call my function (deliciousPermalinks.addPermalinkTag()) and the original function (yAddBookMark.init()).  This approach fell down as soon as I had two extensions trying to modify the onload attribute: I didn't know which extension would be loaded first and therefore one was always overwriting the other.  I'm sure there's a nice way to do this but I hacked together a noddy initialisation script that finds the existing value of the onload attribute and adds to it with the relevant function.

<typo:code>
var yAddBookmarkDialog = document.getElementById('dlg_AddYBookMark');
var yAddBookmarkOnload = yAddBookmarkDialog.getAttribute('onload');
var onload = 'deliciousPermalinks.addPermalinkTag()';
yAddBookmarkDialog.setAttribute('onload', [yAddBookmarkOnload, onload].join(';'))
</typo:code>

I reference this script in my "xul":http://en.wikipedia.org/wiki/XUL file which causes it to be evaluated at (I guess) browser start time and the onload event to be modified correctly.

I've updated the del.icio.us permalinks extension too but I think you'll need to remove and re-add it again from the "installation page":http://groups.google.com/group/delicious-permalinks/files.