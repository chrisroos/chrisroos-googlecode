require 'md5'

class Url < ActiveRecord::Base
  
  belongs_to :domain
  has_many :bookmarks
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
  
  def import_bookmarks_from_delicious!
    delicious_url = Delicious::Url.new(self.url_hash)
    delicious_url.bookmarks.each do |bookmark_attributes|
      self.bookmarks << Bookmark.new_from_delicious_attributes(bookmark_attributes)
    end
  end
  
  def to_param
    url_hash
  end
  
end