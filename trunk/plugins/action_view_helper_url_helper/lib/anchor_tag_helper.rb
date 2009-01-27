class AnchorTagHelper
  
  Regex = /href="(.*?)"/
  
  attr_reader :anchor_tag, :url, :url_without_parameters
  
  def initialize(anchor_tag)
    @anchor_tag = anchor_tag
    anchor_tag = @anchor_tag.gsub("'", "\"")
    @url = anchor_tag.match(Regex)[1] rescue ''
    @url_without_parameters = @url.sub(/\?.*/, '')
  end
  
  def anchor_with_css_class(css_class)
    @anchor_with_css_class ||= @anchor_tag.sub(/^<a /, "<a class=\"#{css_class}\" ")
  end
  
end