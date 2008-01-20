require File.join(MIGRATOR_ROOT, 'environment')

class Tag < ActiveRecord::Base
  has_and_belongs_to_many :articles, :order => 'created_at DESC'
  public :binding
end