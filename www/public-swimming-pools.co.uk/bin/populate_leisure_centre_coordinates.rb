require 'net/http'
require 'yaml'

API_KEY = 'ABQIAAAAKHjf8pvj0mv3o07jD0Tc5RQaqNW12GnHBM9UqBhN-tKTStROsxS_YKqdsgFyjjinVKdFKNOHhZmPOQ'

class GeoCoords
  def initialize(location)
    @location = location
  end
  def coords
    response = Net::HTTP.start('maps.google.com') do |http|
      http.get("/maps/geo?#{querystring}")
    end
    status, accuracy, lat, lng = response.body.split(',')
    [lat, lng].collect { |x| x.to_f }
  end
private
  def querystring
    querystring_data.collect { |key, value| [key, value].join('=') }.join('&')
  end
  def querystring_data
    {
      'q' => URI.escape(@location),
      'key' => API_KEY,
      'output' => 'csv'
    }
  end
end

Dir[File.join(File.dirname(__FILE__), *%w[data *.yaml])].each do |swimming_pool_file|
  next if File.basename(swimming_pool_file) =~ /^__template/
  
  swimming_pool = YAML.load_file(swimming_pool_file)
  if swimming_pool['coords']
    puts "Skipping '#{swimming_pool['name']}', co-ordinates already exist."
  else
    puts "Obtaining co-ordinates for '#{swimming_pool['name']}'"
    swimming_pool['coords'] = GeoCoords.new(swimming_pool['postcode']).coords
    File.open(swimming_pool_file, 'w') { |f| f.puts(swimming_pool.to_yaml) }
  end
end