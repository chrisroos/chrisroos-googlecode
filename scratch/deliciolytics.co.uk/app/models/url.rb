require 'md5'

class Url < ActiveRecord::Base
  
  belongs_to :domain
  validates_presence_of :domain, :url, :url_hash
  validates_uniqueness_of :url
  serialize :top_tags
  before_validation_on_create :hash_url
  
  def hash_url
    self.url_hash = MD5.md5(url).to_s
  end
  
  def update_urlinfo_from_delicious!
    delicious_url    = Delicious::Url.new(self.url_hash)
    self.title       = delicious_url.urlinfo['title']
    self.total_posts = delicious_url.urlinfo['total_posts']
    self.top_tags    = delicious_url.urlinfo['top_tags']
    self.save!
  end
  
end