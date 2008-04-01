class Trackback < ActiveRecord::Base
  
  belongs_to :article
  
  def formatted_published_date
    published_at.strftime("%a, %d %b %Y %H:%M:%S")
  end
  
end