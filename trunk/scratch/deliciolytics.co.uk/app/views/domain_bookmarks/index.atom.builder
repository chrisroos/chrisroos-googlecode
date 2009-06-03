xml.instruct!
xml.feed(:xmlns => 'http://www.w3.org/2005/Atom') do
  xml.title "Bookmarks for #{@domain.domain}"
  xml.link :href => domain_bookmarks_url(@domain)
  xml.link :href => domain_bookmarks_url(@domain, :format => 'atom'), :rel => 'self'
  xml.updated atom_datetime(@domain.most_recent_bookmark_at)
  xml.id tag_uri(@domain)
  @domain.bookmarks.each do |bookmark|
    xml.entry do
      xml.title bookmark.title
      xml.link :href => bookmark.url.url
      xml.updated atom_datetime(bookmark.bookmarked_at)
      xml.author do
        xml.name bookmark.username
      end
      xml.summary bookmark.notes
      xml.id tag_uri(bookmark)
      bookmark.tags.each do |tag|
        xml.category :term => tag
      end
    end
  end
end