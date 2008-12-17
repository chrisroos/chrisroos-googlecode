require 'time'
module DateTimeFormattingHelper
  def rfc822_datetime(page)
    page.created_at.rfc822
  end
  def short_date(page)
    date = page.created_at.strftime("%a, %d %b %y")
    %%<abbr class="createdAt" title="#{page.created_at.xmlschema}">#{date}</abbr>%
  end
end

Webby::Helpers.register(DateTimeFormattingHelper)