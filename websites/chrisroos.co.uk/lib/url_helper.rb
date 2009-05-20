module UrlHelper
  def friendly_url(page)
    page.url.sub(/\.html$/, '')
  end
end

Webby::Helpers.register(UrlHelper)