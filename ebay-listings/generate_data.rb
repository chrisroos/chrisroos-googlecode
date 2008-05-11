require 'flickr'

name = ARGV.shift
dimensions = ARGV.shift
weight = ARGV.shift
tag = ARGV.shift

unless name && dimensions && weight
  puts "Usage: ruby generate_data.rb name-of-item dimensions (wxhxd) weight [tag]"
  exit
end

description = ''
while line = gets
  description << line
end

w, h, d = dimensions.split('x').collect { |x| Float(x) }
volumetric_weight = (w * h * d) / 6000
photos = Photos.get(tag)
data = {
  :name => name,
  :dimensions => dimensions,
  :weight => weight,
  :volumetric_weight => volumetric_weight,
  :tag => tag,
  :photos => photos,
  :description => description
}

require 'yaml'

File.open(File.join('listings', name), 'w') { |f| f.puts(data.to_yaml) }
