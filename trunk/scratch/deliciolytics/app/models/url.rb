class Url < ActiveRecord::Base
  validates_presence_of :url, :hash, :title
  serialize :top_tags
end