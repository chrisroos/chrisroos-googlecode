require File.join(MIGRATOR_ROOT, 'environment')
require 'redcloth'

class Comment < ActiveRecord::Base
  belongs_to :article
  def body_html
    RedCloth.new(body).to_html(:textile)
  end
  def formatted_created_date
    created_at.strftime("%a, %d %b %Y %H:%M:%S")
  end
end