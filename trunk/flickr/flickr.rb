require 'rubygems'
require 'digest/md5'
require 'json'
require 'net/http'
require 'uri'

class Flickr; end

auth_token_filename = File.join(File.dirname(__FILE__), '/AUTH_TOKEN')
Flickr::AUTH_TOKEN = if File.exist?(auth_token_filename) then
  File.open(auth_token_filename) { |file| file.read }
else
  nil
end

class Flickr
  API_KEY = '07158d4b46a88c14ad3270218dba136b'
  SHARED_SECRET = 'fb4036266c025867'
  
  REST_URL = 'http://api.flickr.com/services/rest/'
  AUTH_URL = 'http://flickr.com/services/auth/'
  
  AUTH_PARAMETERS = {
    'api_key' => API_KEY
  }
  REST_PARAMETERS = {
    'api_key' => API_KEY,
    'format' => 'json'
  }
  
  def initialize(parameters, default_parameters = REST_PARAMETERS)
    @parameters = default_parameters.merge(parameters)
  end
  def url_with_parameters(signed = true, url = REST_URL, authorized = true)
    @parameters['auth_token'] = AUTH_TOKEN if authorized
    parameters = signed ? signed_params(@parameters) : unsigned_params(@parameters)
    "#{url}?#{parameters}"
  end
  def call(signed = true, url = REST_URL, authorized = true)
    uri = URI.parse(url_with_parameters(signed, url, authorized))
    response = Net::HTTP.get(uri)
    extract_json(response)
  end
private
  def signature(params)
    params_for_signature = SHARED_SECRET + params.sort.flatten.join('')
    Digest::MD5.hexdigest(params_for_signature)
  end
  def signed_params(params)
    signature = signature(params)
    params['api_sig'] = signature
    params.collect { |key_value| key_value.join('=') }.join('&')
  end
  def unsigned_params(params)
    params.collect { |key_value| key_value.join('=') }.join('&')
  end
  def extract_json(json)
    json = json[/jsonFlickrApi\((.*)\)/, 1]
    JSON.parse(json)
  end
end

class Authenticator
  def self.authenticate
    authenticator = Authenticator.new
    frob = authenticator.get_frob
    authenticator.register_frob(frob)
    puts "Press a key once you've allowed access"
    until gets; end
    token = authenticator.get_token(frob)
    File.open(File.dirname(__FILE__) + '/AUTH_TOKEN', 'w') do |file|
      file << token
    end
    puts "All done."
  end
  def get_frob
    flickr = Flickr.new('method' => 'flickr.auth.getFrob')
    response = flickr.call
    response['frob']['_content']
  end
  def register_frob(frob)
    flickr = Flickr.new({'perms' => 'delete', 'frob' => frob}, Flickr::AUTH_PARAMETERS)
    flickr_url = flickr.url_with_parameters(true, Flickr::AUTH_URL, false)
    `open "#{flickr_url}"`
  end
  def get_token(frob)
    flickr = Flickr.new('method' => 'flickr.auth.getToken', 'frob' => frob)
    response = flickr.call
    response['auth']['token']['_content']
  end
end

class Photoset < Struct.new(:title, :primary, :farm, :photos, :id, :description, :server, :owner, :secret)
  alias_method :number_of_photos, :photos # alias the photos method that we can re-create it to return the actual photos in this set
  class << self
    def find(id)
      flickr = Flickr.new('method' => 'flickr.photosets.getInfo', 'photoset_id' => id)
      response = flickr.call
      Photoset.build_from_json(response['photoset'])
    end
    def find_all
      flickr = Flickr.new('method' => 'flickr.photosets.getList')
      response = flickr.call
      response['photosets']['photoset'].collect { |json_photoset| Photoset.build_from_json(json_photoset) }
    end
    def build_from_json(json_photoset)
      Photoset.new(json_photoset['title']['_content'], json_photoset['primary'], json_photoset['farm'], json_photoset['photos'], json_photoset['id'], json_photoset['description']['_content'], json_photoset['server'], json_photoset['owner'], json_photoset['secret'])
    end
  end
  def photos
    @photos ||= (flickr = Flickr.new('method' => 'flickr.photosets.getPhotos', 'photoset_id' => self.id)
    response = flickr.call
    response['photoset']['photo'].collect { |json_photo| Photo.build_from_json(json_photo) })
  end
  def filesystem_friendly_title
    self.title.gsub(/ /, '_')
  end
  def delete
    flickr = Flickr.new('method' => 'flickr.photosets.delete', 'photoset_id' => self.id)
    response = flickr.call
    response['stat'] == 'ok'
  end
end

class Photo < Struct.new(:isprimary, :title, :farm, :id, :server, :secret)
  class << self
    def build_from_json(json_photo)
      Photo.new(json_photo['isprimary'], json_photo['title'], json_photo['farm'], json_photo['id'], json_photo['server'], json_photo['secret'])
    end
  end
  def original_image_url
    flickr = Flickr.new('method' => 'flickr.photos.getSizes', 'photo_id' => self.id)
    flickr.call['sizes']['size'].find { |size| size['label'] == 'Original' }['source']
  end
  def save_to_filesystem(path)
    photo_uri = URI.parse(original_image_url)
    File.open(path, 'w') { |file| file << Net::HTTP.get(photo_uri) }
  end
end