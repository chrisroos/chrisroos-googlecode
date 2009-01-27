require 'http_client'
require 'micro_id_verifier'

class LinkStatus
  Unprocessed = 1
  VerificationSuccess = 2
  VerificationFailure = 3
  VerificationError = 4
end

class Link < ActiveRecord::Base
  
  class << self
    
    def all_links
      Link.find(:all)
    end
    
    def find_all_unverified(links = all_links)
      links.select { |link| link.status == 1 }
    end
    
    def verify_all(links = all_links)
      find_all_unverified(links).each do |unverified_link|
        unverified_link.verify_micro_id!
      end
    end
    
  end
  
  def after_initialize
    self.status = LinkStatus::Unprocessed unless self.status
  end
  
  def get_html(http_client = HttpClient.new)
    http_client.get_html(url) rescue nil
  end
  
  def verify_micro_id!(micro_id_verifier = MicroIdVerifier.new)
    unless (html = get_html)
      status = LinkStatus::VerificationError
    else
      success = micro_id_verifier.verify(html, expected_micro_id)
      status = success ? LinkStatus::VerificationSuccess : LinkStatus::VerificationFailure
    end
    update_attributes(:status => status)
  end
  
end