require 'builder'
require File.join(File.dirname(__FILE__), *%w[.. lib swimming_pools])

kml_buffer = StringIO.new

builder = Builder::XmlMarkup.new(:target => kml_buffer, :indent => 2)
builder.instruct!
builder.kml(:xmlns => 'http://earth.google.com/kml/2.2') do
  builder.Document do
    SwimmingPools.find_all.each do |swimming_pool|
      builder.Placemark do 
        builder.name(swimming_pool.name)
        builder.description(swimming_pool.address)
        builder.Point do
          builder.coordinates(swimming_pool.kml_coordinates)
        end
      end
    end
  end
end

File.open(File.join(File.dirname(__FILE__), *%w[.. public swimming-pools.kml]), 'w') { |f| f.puts(kml_buffer.string) }