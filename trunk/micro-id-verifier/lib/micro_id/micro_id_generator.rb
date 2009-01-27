require 'digest/sha1'

class MicroIdGenerator
  
  attr_reader :email, :url
  
  def initialize(email, url)
    @email, @url = email, url
  end
  
  def micro_id
    email_digest = Digest::SHA1.new(email).to_s
    url_digest = Digest::SHA1.new(url).to_s
    Digest::SHA1.new(email_digest + url_digest).to_s
  end

end