class Edition < ActiveRecord::Base
  belongs_to :paper
  has_many :articles
  validates_presence_of :paper, :published_on, :label
  validates_associated :paper
end
