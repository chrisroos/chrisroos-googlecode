class Bookmark < ActiveRecord::Base
  
  belongs_to :url
  validates_presence_of :url
  validates_uniqueness_of :username, :scope => :url_id
  serialize :tags
  
  def self.new_from_delicious_attributes(delicious_attributes)
    new(Delicious::BookmarkAttributeConvertor.convert(delicious_attributes))
  end
  
end