# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def link_to_source_url(url)
    link_to h(url.url), h(url.url)
  end
  
  def link_to_delicious_url_history(url)
    link_to h(url.url_hash), h("http://delicious.com/url/#{url.url_hash}")
  end
  
  def link_to_delicious_user(username)
    link_to h(username), h("http://delicious.com/#{username}")
  end
  
  def linked_tag_list(tags_and_counts)
    return unless tags_and_counts # For Urls that don't have (or we haven't collected) any url tags_and_counts
    ordered_tags = tags_and_counts.sort_by { |tag, count| count }.reverse.collect { |tag, count| tag }
    linked_tags(ordered_tags)
  end
  
  def linked_tags(tags)
    tags.collect do |tag|
      link_to h(tag), h("http://delicious.com/tag/#{tag}")
    end.join(', ')
  end
  
end
