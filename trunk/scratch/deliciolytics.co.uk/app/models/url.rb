require 'md5'

class Url < ActiveRecord::Base
  
  belongs_to :domain
  validates_presence_of :domain, :url, :url_hash
  serialize :top_tags
  before_validation_on_create :hash_url
  
  def hash_url
    self.url_hash = MD5.md5(url).to_s
  end
  
end