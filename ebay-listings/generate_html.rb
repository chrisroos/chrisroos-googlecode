require 'erb'

template = File.open(template.erb.html) { |f| f.read }
erb = ERB.new(template)

