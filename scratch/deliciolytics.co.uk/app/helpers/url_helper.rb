module UrlHelper
  
  def url(url)
    h(url.url)
  end
  
  def url_path(url)
    URI.parse(url.url).path
  end
  
end