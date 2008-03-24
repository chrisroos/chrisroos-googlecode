require 'redcloth'

class Comment < ActiveRecord::Base
  
  belongs_to :article
  
  def body_html
    RedCloth.new(body).to_html(:textile)
  end
  
  def formatted_published_date
    published_at.strftime("%a, %d %b %Y %H:%M:%S")
  end
  
end