require 'ing-direct-credentials'

COOKIE_JAR = '/tmp/ing-direct.cookie'
TRANSACTIONS_FILENAME = '/Users/chrisroos/Desktop/ing-transactions.html'

# POST our customer number and surname
curl_cmd = %[curl -s -X"POST" -c"#{COOKIE_JAR}" -d"command=enterCustomerNumber" -d"locale=en_GB" -d"device=web" -d"ACN=#{CUSTOMER_NUMBER}" -d"LNAME=#{LAST_NAME}" -d"GO.x=23" -d"GO.y=12" "https://secure.ingdirect.co.uk/InitialINGDirect.html"]
`#{curl_cmd}`

# GET the keypad security page
curl_cmd = %[curl -s -b"#{COOKIE_JAR}" "https://secure.ingdirect.co.uk/INGDirect.html?command=displayValidateCustomer&fill=1"]
keypad_page_html = `#{curl_cmd}`

# Find the digits that are being requested
pin_a_digit, pin_b_digit, pin_c_digit = keypad_page_html.scan(/Using the Key Pad, please enter the (\d).+?(\d).+?(\d).*?<\/b>/).flatten.collect { |digit| digit.to_i }
# Pull out the relevant parts of our pin number
pin_a = PIN.split('')[pin_a_digit - 1]
pin_b = PIN.split('')[pin_b_digit - 1]
pin_c = PIN.split('')[pin_c_digit - 1]

require 'rubygems'
require 'hpricot'

# Represent the keypad as an array
doc = Hpricot(keypad_page_html)
keypad = (doc/'div#pin-pad/table/tr/td/input').inject([]) { |array, btn| array << btn.attributes['value'].to_i; array }
keypad.unshift(keypad.pop)

# Derive the positions of the digits from our pin on the keypad
pin_a_position = keypad.index(pin_a.to_i)
pin_b_position = keypad.index(pin_b.to_i)
pin_c_position = keypad.index(pin_c.to_i)

# Derive the positions of the digits that make up our memorable date on the keypad
day_1, day_2 = DATE_DAY.split('').collect { |d| d.to_i }
days_positions = [keypad.index(day_1), keypad.index(day_2)].join('')
month_1, month_2 = DATE_MONTH.split('').collect { |d| d.to_i }
months_positions = [keypad.index(month_1), keypad.index(month_2)].join('')
year_1, year_2 = DATE_YEAR.split('').collect { |d| d.to_i }
years_positions = [keypad.index(year_1), keypad.index(year_2)].join('')

# POST our security details and log in
curl_cmd = %[curl -s -b"#{COOKIE_JAR}" -X"POST" "https://secure.ingdirect.co.uk/InitialINGDirect.html" -d"command=validateCustomer" -d"locale=en_GB" -d"device=web" -d"PIN_A=#{pin_a_position}" -d"PIN_B=#{pin_b_position}" -d"PIN_C=#{pin_c_position}" -d"DAYS=#{days_positions}" -d"MONTHS=#{months_positions}" -d"YEARS=#{years_positions}" -d"GO.x=23" -d"GO.y=14"]
`#{curl_cmd}`

# Yields javascript redirect
curl_cmd = %[curl -s -b"#{COOKIE_JAR}" "https://secure.ingdirect.co.uk/INGDirect.html" -d"command=accountSummary" -d"locale=en_GB" -d"device=web" -d"method=fetchClientAccountSummary"]
`#{curl_cmd}`

# Yields account overview
curl_cmd = %[curl -s -b"#{COOKIE_JAR}" "https://secure.ingdirect.co.uk/INGDirect.html" -d"command=displayClientAccountSummary" -d"fill=1"]
`#{curl_cmd}`

# Yields javascript redirect
curl_cmd = %[curl -s -b"#{COOKIE_JAR}" "https://secure.ingdirect.co.uk/INGDirect.html" -d"command=accountSummary" -d"method=fetchClientAccountSummary" -d"account=0" -d"stepName=saving"]
`#{curl_cmd}`

# Yields account transactions - let's save this one
curl_cmd = %[curl -o"#{TRANSACTIONS_FILENAME}" -s -b"#{COOKIE_JAR}" "https://secure.ingdirect.co.uk/INGDirect.html" -d"command=displayAccountDetails"]
`#{curl_cmd}`