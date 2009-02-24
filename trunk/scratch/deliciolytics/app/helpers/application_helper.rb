# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def link_to_delicious_url_history(url)
    link_to h(url.url_hash), "http://delicious.com/url/#{url.url_hash}"
  end
  
  def tags_list(tags_and_counts)
    ordered_tags = tags_and_counts.sort_by { |tag, count| count }.reverse.collect { |tag, count| tag }
    h(ordered_tags.join(', '))
  end
  
end
