#!/usr/bin/env ruby

require 'flickr'

photoset_id = ARGV.shift
raise "Must supply photoset_id" unless photoset_id
local_photo_dir = ARGV.shift
raise "Must supply local photo dir" unless local_photo_dir

photoset = Photoset.find(photoset_id)
local_photo_dir = File.join(local_photo_dir, photoset.filesystem_friendly_title)
number_of_photos = photoset.number_of_photos
current_photo = 0

Dir.mkdir(local_photo_dir) unless File.exist?(local_photo_dir)

photoset.photos.each do |photo|
  current_photo += 1

  filepath = File.join(local_photo_dir, photo.title)
  filepath = filepath + '.jpg' unless filepath =~ /\.jpg$/

  if File.exists?(filepath)
    puts "Skipping photo #{photo.id} (already downloaded) #{current_photo} of #{number_of_photos}"
  else
    puts "Retrieving photo #{current_photo} of #{number_of_photos}"
    photo.save_to_filesystem(filepath)
  end
end