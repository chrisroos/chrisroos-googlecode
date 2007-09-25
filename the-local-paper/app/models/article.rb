class Article < ActiveRecord::Base
  
  belongs_to :edition
  validates_presence_of :edition, :title, :page_number
  validates_associated :edition
  
  def self.find_recent
    find :all, :include => [:edition], :limit => 10, :order => 'editions.published_on asc'
  end
  
end