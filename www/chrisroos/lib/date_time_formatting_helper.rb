require 'time'
module DateTimeFormattingHelper
  def formatted_created_date(page)
    page.created_at.strftime("%a, %d %b %Y %H:%M:%S")
  end
  def rfc822_datetime(page)
    page.created_at.rfc822
  end
end

Webby::Helpers.register(DateTimeFormattingHelper)