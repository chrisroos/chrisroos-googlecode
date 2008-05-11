require 'erb'
require 'yaml'
require 'redcloth'

template = File.open('template.erb.html') { |f| f.read }
erb = ERB.new(template)

Dir['listings/*'].each do |listing_filename|
  listing = YAML.load_file(listing_filename)
  html = erb.result(binding)
  File.open(File.join('html', "#{File.basename(listing_filename)}.html"), 'w') { |f| f.puts(html) }
end
