require File.join(MIGRATOR_ROOT, 'environment')

class Tag < ActiveRecord::Base
  
  has_and_belongs_to_many :articles, :order => 'created_at DESC'
  
  def path
    TAGS_URL_ROOT
  end
  
  def url
    # Representation agnostic (i.e. doesn't specify .html, .xml)
    File.join(path, name)
  end
  
  public :binding
  
end