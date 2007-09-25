class Paper < ActiveRecord::Base
  has_many :editions
  validates_presence_of :title
end
