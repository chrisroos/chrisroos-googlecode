require 'flickr'

dimensions, weight, tag = ARGV
w, h, d = dimensions.split('x').collect { |x| Float(x) }
volumetric_weight = (w * h * d) / 6000
photos = Photos.get(tag)

