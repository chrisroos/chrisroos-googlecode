class Resource < ActiveRecord::Base
  
  has_and_belongs_to_many :tags
  
  def tag(tag_name)
    tags << Tag.find_or_create_by_name(tag_name)
  end
  
end