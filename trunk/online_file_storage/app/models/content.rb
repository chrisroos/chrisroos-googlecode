class Content < ActiveRecord::Base
  
  validates_presence_of :title, :body
  
  def self.find_with_title_like(title)
    title = '' unless title
    find(:all, :conditions => ["title LIKE :title", {:title => '%' + title + '%'}])
  end
  
end
