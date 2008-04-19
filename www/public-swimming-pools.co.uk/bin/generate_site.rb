require 'erb'
include ERB::Util
require File.join(File.dirname(__FILE__), *%w[.. lib swimming_pools])

template = File.read(File.join(File.dirname(__FILE__), *%w[swimming-pool.html.erb]))
public_dir = File.join(File.dirname(__FILE__), '..', 'public')

SwimmingPools.find_all.each do |swimming_pool|
  erb = ERB.new(template)
  File.open(File.join(public_dir, "#{swimming_pool.permalink}.html"), 'w') do |file|
    file.puts(erb.result(binding))
  end
end

template = File.read(File.join(File.dirname(__FILE__), *%w[index.html.erb]))
erb = ERB.new(template)
File.open(File.join(public_dir, "index.html"), 'w') do |file|
  file.puts(erb.result(binding))
end