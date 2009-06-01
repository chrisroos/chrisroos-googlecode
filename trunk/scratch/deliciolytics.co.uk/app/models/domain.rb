require 'md5'

class Domain < ActiveRecord::Base
  
  has_many :urls
  validates_presence_of :domain, :domain_hash
  validates_uniqueness_of :domain
  before_validation_on_create :hash_domain
  
  def hash_domain
    self.domain_hash = MD5.md5(domain).to_s
  end
  
  def to_param
    domain_hash
  end
  
  def retrieve_urls_from_sitemap
    sitemap = Sitemap.new(domain)
    sitemap.urls.each do |url|
      self.urls.create!(:url => url)
    end
  end
  
end