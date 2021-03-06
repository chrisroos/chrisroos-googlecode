require 'md5'

class Domain < ActiveRecord::Base
  
  has_many :urls
  has_many :bookmarks, :through => :urls, :order => 'bookmarked_at DESC'
  has_many :domain_events, :order => 'started_at DESC'
  
  validates_presence_of :domain
  validates_uniqueness_of :domain
  
  before_create :set_default_state
  
  def normalise!
    return unless new?
    log_event('normalising') do 
      self.domain      = DomainUrlNormaliser.normalise(self)
      self.domain_hash = MD5.md5(domain).to_s
      self.state       = 'normalised'
      save
    end
  end
  
  def most_recent_bookmark_at
    bookmarks.first.bookmarked_at
  end
  
  def to_param
    domain_hash
  end
  
  def retrieve_urls_from_sitemap!
    log_event('updating urls from sitemap') do
      sitemap = Sitemap.new(domain)
      sitemap.urls.each do |url|
        self.urls.create(:url => url)
      end
    end
  end
  
  def update_urlinfo_from_delicious!(interval = 0.5)
    log_event('updating urlinfo from delicious') do
      self.urls.each { |url| url.update_urlinfo_from_delicious!; sleep interval }
    end
  end
  
  def import_bookmarks_from_delicious!(interval = 0.5)
    log_event('importing bookmarks from delicious') do
      self.urls.each { |url| url.import_bookmarks_from_delicious!; sleep interval }
    end
  end
  
  def normalised?
    state == 'normalised'
  end
  
private
  
  def set_default_state
    self.state = 'new'
  end
  
  def new?
    state == 'new'
  end
  
  def log_event(description, &blk)
    event = self.domain_events.create!(:description => description)
    yield
    event.finish!
  end
  
end