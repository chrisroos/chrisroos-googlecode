module DateTimeFormattingHelper
  def formatted_created_date(page)
    page.created_at.strftime("%a, %d %b %Y %H:%M:%S")
  end
end

Webby::Helpers.register(DateTimeFormattingHelper)