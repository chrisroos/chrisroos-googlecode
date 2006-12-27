require 'rubygems'
require 'digest/md5'
require 'json'

# #*** GET FROB
# 
# parameter_options = {
#   'method' => 'flickr.auth.getFrob',
#   'api_key' => API_KEY,
#   'format' => 'json'
# }
# 
# returned_json = return_value(`curl "#{REST_URL}?#{signed_params(parameter_options)}"`)
# frob = returned_json['frob']['_content']
# # frob = '6175306-226e5a1f11c943f6'
# 
# #*** AUTHORIZE FROB USE
# 
# parameter_options = {
#   'api_key' => API_KEY,
#   'perms' => 'read',
#   'frob' => frob
# }
# url = %[#{AUTH_URL}?#{signed_params(parameter_options)}]
# `open "#{url}"`
# 
# sleep 15
# 
# #*** GET TOKEN
# 
# parameter_options = {
#  'method' => 'flickr.auth.getToken',
#  'api_key' => API_KEY,
#  'frob' => frob,
#  'format' => 'json'
# }
# 
# curl_cmd = %[curl "#{REST_URL}?#{signed_params(parameter_options)}"]
# returned_json = `#{curl_cmd}`
# token = return_value(returned_json)['auth']['token']['_content']
# puts "token = #{token}"


require 'flickr_credentials'
require 'net/http'
require 'uri'

class Flickr
  REST_URL = 'http://api.flickr.com/services/rest/'
  AUTH_URL = 'http://flickr.com/services/auth/'
  
  DEFAULT_PARAMETERS = {
    'api_key' => API_KEY,     
    'auth_token' => TOKEN,
    'format' => 'json'
  }
  
  def initialize(parameters)
    @parameters = DEFAULT_PARAMETERS.merge(parameters)
  end
  def call(signed = true)
    parameters = signed ? signed_params(@parameters) : unsigned_params(@parameters)
    uri = URI.parse("#{REST_URL}?#{parameters}")
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

class Photoset < Struct.new(:title, :primary, :farm, :photos, :id, :description, :server, :owner, :secret)
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
  def number_of_photos
    photos.size
  end
  def filesystem_friendly_title
    self.title.gsub(/ /, '_')
  end
end

class Photo < Struct.new(:isprimary, :title, :farm, :id, :server, :secret)
  class << self
    def build_from_json(json_photo)
      Photo.new(json_photo['isprimary'], json_photo['title'], json_photo['farm'], json_photo['id'], json_photo['server'], json_photo['secret'])
    end
  end
  def original_image_url
    "http://static.flickr.com/#{self.server}/#{self.id}_#{self.secret}_o_d.jpg"
  end
  def save_to_filesystem(path)
    photo_uri = URI.parse(original_image_url)
    File.open(path, 'w') { |file| file << Net::HTTP.get(photo_uri) }
  end
end