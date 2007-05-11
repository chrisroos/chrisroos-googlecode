# SO FAR THIS GETS US TO THE ACCOUNT OVERVIEW PAGE - NOW NEED TO SELECT ACCOUNT AND DOWNLOAD RECENT TRANSACTIONS

require 'lloydstsb_credentials'

require 'rubygems'
require 'hpricot'

COOKIE_LOCATION = '/Users/chrisroos/lloydstsb_cookie'

# Store some cookies for later
curl_cmd = %[curl -s -c"#{COOKIE_LOCATION}" "https://online.lloydstsb.co.uk/customer.ibc"]
html = `#{curl_cmd}`

# Obtain the key that we need to POST along with our Username and Password
doc = Hpricot(html)
key = (doc/'input[@name=Key]').first.attributes['value']

# POST the key, userid and password
curl_cmd = %[curl -s -b"#{COOKIE_LOCATION}" "https://online.lloydstsb.co.uk/logon.ibc" -d"Java=Off" -d"Key=#{key}" -d"UserId1=#{USERID}" -d"Password=#{PASSWORD}"]
html = `#{curl_cmd}`

# Obtain the three characters from our memorable info that we need to POST
doc = Hpricot(html)
position_of_char1 = Integer((doc/'input[@name=ResponseKey0]').first.attributes['value'])
position_of_char2 = Integer((doc/'input[@name=ResponseKey1]').first.attributes['value'])
position_of_char3 = Integer((doc/'input[@name=ResponseKey2]').first.attributes['value'])
char1 = MEMORABLE.split('')[position_of_char1 - 1]
char2 = MEMORABLE.split('')[position_of_char2 - 1]
char3 = MEMORABLE.split('')[position_of_char3 - 1]

# POST our memorable info
curl_cmd = %[curl -s -L -b"#{COOKIE_LOCATION}" "https://online.lloydstsb.co.uk/miheld.ibc" -d"ResponseKey0=#{position_of_char1}" -d"ResponseValue0=#{char1}" -d"ResponseKey1=#{position_of_char2}" -d"ResponseValue1=#{char2}" -d"ResponseKey2=#{position_of_char3}" -d"ResponseValue2=#{char3}"]
html = `#{curl_cmd}`

# TEMPORARILY OUTPUT HTML SO WE CAN CHECK ALL IS OK
File.open('/Users/chrisroos/Desktop/wem.html', 'w') { |f| f.puts(html) }

# Remove the cookie
`rm #{COOKIE_LOCATION}`