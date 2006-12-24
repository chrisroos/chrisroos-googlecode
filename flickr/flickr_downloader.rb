require 'rubygems'
require 'digest/md5'
require 'json'
require 'cgi'

class Flickr
  REST_URL = 'http://api.flickr.com/services/rest/'
  AUTH_URL = 'http://flickr.com/services/auth/'
  API_KEY = 'YOUR_API_KEY'
  SHARED_SECRET = 'YOUR_SHARED_SECRET'
  TOKEN = 'YOUR_AUTH_TOKEN'
  
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
    curl_cmd = %[curl "#{REST_URL}?#{parameters}"]
    response = `#{curl_cmd}`
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
end

photoset = Photoset.find('PHOTOSET_ID')
local_photo_dir = '/users/chrisroos/desktop/pics/' + photoset.filesystem_friendly_title + '/'
number_of_photos = photoset.number_of_photos
current_photo = 0

Dir.mkdir(local_photo_dir) unless File.exist?(local_photo_dir)

photoset.photos.each do |photo|
  current_photo += 1

  filepath = local_photo_dir + photo.title + '.jpg'

  if File.exists?(filepath)
    puts "Skipping photo (already downloaded) #{current_photo} of #{number_of_photos}"
  else
    puts "Retrieving photo #{current_photo} of #{number_of_photos}"
    curl_cmd = %[curl "#{photo.original_image_url}" > "#{filepath}"]
    `#{curl_cmd}`
  end
end