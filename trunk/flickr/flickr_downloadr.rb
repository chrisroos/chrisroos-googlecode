#!/usr/bin/env ruby

require 'flickr'

photoset_id = ARGV.shift
raise "Must supply photoset_id" unless photoset_id
local_photo_dir = ARGV.shift
raise "Must supply local photo dir" unless local_photo_dir

photoset = Photoset.find(photoset_id)
local_photo_dir = local_photo_dir + photoset.filesystem_friendly_title + '/'
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