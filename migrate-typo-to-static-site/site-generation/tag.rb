require File.join(MIGRATOR_ROOT, 'environment')

class Tag < ActiveRecord::Base
  
  has_and_belongs_to_many :articles, :order => 'created_at DESC'
  
  def path
    File.join(ARTICLES_ROOT, 'tag')
  end
  
  public :binding
  
end