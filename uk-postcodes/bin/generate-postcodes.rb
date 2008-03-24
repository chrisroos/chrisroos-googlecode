require 'json'

public_directory = File.join(File.dirname(__FILE__), '..', 'public')
postcodes_file = File.join(File.dirname(__FILE__), '..', 'data', 'uk-postcodes.json')

postcodes = JSON.parse(File.open(postcodes_file) { |f| f.read })
postcodes.each do |postcode_data|
  outcode = postcode_data['postcode'].downcase
  File.open(File.join(public_directory, "#{outcode}.html"), 'w') { |f| f.puts(postcode_data.to_json) }
end