require 'md5'

class Domain < ActiveRecord::Base
  
  has_many :urls
  has_many :bookmarks, :through => :urls, :order => 'bookmarked_at DESC'
  
  validates_presence_of :domain
  validates_uniqueness_of :domain
  
  before_create :set_default_state
  
  def normalise!
    self.domain      = DomainUrlNormaliser.normalise(self)
    self.domain_hash = MD5.md5(domain).to_s
    self.state       = 'normalised'
    save
  end
  
  def most_recent_bookmark_at
    bookmarks.first.bookmarked_at
  end
  
  def to_param
    domain_hash
  end
  
  def retrieve_urls_from_sitemap!
    sitemap = Sitemap.new(domain)
    sitemap.urls.each do |url|
      self.urls.create(:url => url)
    end
  end
  
  def update_urlinfo_from_delicious!
    self.urls.each { |url| url.update_urlinfo_from_delicious!; sleep 0.5 }
  end
  
  def import_bookmarks_from_delicious!
    self.urls.each { |url| url.import_bookmarks_from_delicious!; sleep 0.5 }
  end
  
private
  
  def set_default_state
    self.state = 'new'
  end
  
end