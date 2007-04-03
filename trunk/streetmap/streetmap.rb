postcode = 'SW1A 2AJ'

html = `curl "http://streetmap.co.uk/streetmap.dll" -d"MfcISAPICommand=GridConvert" -d"name=#{postcode}" -d"type=PostCode"`

require 'rubygems'
require 'hpricot'

doc = Hpricot(html)

latitude, longitude = 0, 0

(doc/"div"/"center"/"table"/"tr").each do |row|
  attribute = (row/"td").first.inner_text
  value = (row/"td").last.inner_text
  if attribute =~ /lat/i
    latitude = Float(value[/\((.*)\)/, 1])
  elsif attribute =~ /long/i
    longitude = Float(value[/\((.*)\)/, 1])
  end
end

p [latitude, longitude]