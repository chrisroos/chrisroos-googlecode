require 'cgi'

API_KEY = 'API_KEY'
PHOTOSET_ID = 'PHOTOSET_ID'
LOCAL_PHOTO_DIR = '/users/chrisroos/desktop/photos/'

curl_cmd = %[curl "http://api.flickr.com/services/rest/?method=flickr.photosets.getPhotos&api_key=#{API_KEY}&photoset_id=#{PHOTOSET_ID}"]
photoset_photos = `#{curl_cmd}`

number_of_photos = photoset_photos.scan(/<photo .*>/).size
current_photo = 0

photoset_photos.scan(/<photo .*>/) do |line|
  current_photo += 1
  
  photo_id = line[/id="(\d+)"/, 1]
  photo_secret = line[/secret="(\w+)"/, 1]
  photo_server = line[/server="(\d+)"/, 1]
  photo_title = line[/title="(.+?)"/, 1]
  
  url = "http://static.flickr.com/#{photo_server}/#{photo_id}_#{photo_secret}_o_d.jpg"
  filename = CGI.unescapeHTML(photo_title).gsub(/ |&|,|-/, '_').gsub(/'/, '').downcase.squeeze('_') + '_' + photo_id + '.jpg' # Sanitize title to use as filename
  filepath = LOCAL_PHOTO_DIR + filename
  
  if File.exists?(filepath)
    puts "Skipping photo (already downloaded) #{current_photo} of #{number_of_photos}"
  else
    puts "Retrieving photo #{current_photo} of #{number_of_photos}"
    curl_cmd = %[curl "#{url}" > "#{filepath}"]
    `#{curl_cmd}`
  end
end