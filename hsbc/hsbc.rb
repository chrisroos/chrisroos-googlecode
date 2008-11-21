require 'yaml'

# Load the credentials from a file or STDIN (to allow us to read in encrypted output from a gpg command)
# e.g. gpg --decrypt encrypted_credentials.yml | ruby hsbc.rb
if credentials_filename = ARGV.shift
  Credentials = YAML.load(File.read(credentials_filename))
else
  yaml_credentials = ''
  while data = gets
    yaml_credentials << data
  end
  Credentials = YAML.load(yaml_credentials)
end

sort_code = Credentials['sort_code']
account_number = Credentials['account_number']
internet_banking_id = Credentials['internet_banking_id']
date_of_birth = Credentials['date_of_birth']
password = Credentials['password']

class << password
  [:first, :second, :third, :fourth, :fifth, :sixth, :next_to_last, :last].each_with_index do |method, index|
    define_method(method) do
      digits = self.split('')
      return digits.last if method == :last
      return digits[-2] if method == :next_to_last
      return digits[index]
    end
  end
end

require 'hpricot'
require 'net/https'
require 'uri'

class CookieJar < Hash
  def to_cookie
    collect { |key, value| "#{key}=#{value}" }.join(';')
  end
end

COOKIE_JAR = CookieJar.new

### GET the homepage so that we can get the url (including jsessionid) of the page that asks for our internet banking id
debug_buffer = ''; debug_stream = StringIO.new(debug_buffer)
homepage_url = 'http://www.hsbc.co.uk/1/2/'
url = URI.parse(homepage_url)
request = Net::HTTP::Get.new(url.request_uri)
request['User-Agent'] = 'Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.5; en-US; rv:1.9.0.4) Gecko/2008102920 Firefox/3.0.4'
http = Net::HTTP.new(url.host, url.port)
http.set_debug_output(debug_stream)
response = http.start { |http| http.request(request) }
response.to_hash['set-cookie'].each { |cookie_string| cookie_string =~ /(.*?)=(.*?);/; COOKIE_JAR[$1] = $2 }
html = response.body
File.open('1-get-homepage.txt', 'w') { |f| f.puts(debug_buffer) }
File.open('1-get-homepage.html', 'w') { |f| f.puts(html) }
doc = Hpricot(html)
link_to_personal_banking_login_page = doc.at('a[@href*=HSBCINTEGRATION]')
link_to_personal_banking_login_page_href = link_to_personal_banking_login_page.attributes['href']

### GET the page that asks for our internet banking id
debug_buffer = ''; debug_stream = StringIO.new(debug_buffer)
internet_banking_id_url = 'http://www.hsbc.co.uk' + link_to_personal_banking_login_page_href
url = URI.parse(internet_banking_id_url)
request = Net::HTTP::Get.new(url.request_uri)
request['User-Agent'] = 'Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.5; en-US; rv:1.9.0.4) Gecko/2008102920 Firefox/3.0.4'
request['Cookie'] = COOKIE_JAR.to_cookie
request['Referer'] = homepage_url
http = Net::HTTP.new(url.host, url.port)
http.set_debug_output(debug_stream)
response = http.start { |http| http.request(request) }
response.to_hash['set-cookie'].each { |cookie_string| cookie_string =~ /(.*?)=(.*?);/; COOKIE_JAR[$1] = $2 }
html = response.body
File.open('2-get-logon.txt', 'w') { |f| f.puts(debug_buffer) }
File.open('2-get-logon.html', 'w') { |f| f.puts(html) }
doc = Hpricot(html)
html_form = doc.at('form#IBloginForm')
html_form_action = html_form.attributes['action']
html_form_internet_banking_field = html_form.at('input#intbankingID')
html_form_internet_banking_field_name = html_form_internet_banking_field.attributes['name']
html_form_hidden_fields = html_form.search('input[@type=hidden]')
request_body = html_form_hidden_fields.inject({}) { |hash, element| hash[element.attributes['name']] = element.attributes['value']; hash }
request_body.merge!(html_form_internet_banking_field_name => internet_banking_id)

### POST our internet banking id
debug_buffer = ''; debug_stream = StringIO.new(debug_buffer)
url = URI.parse(html_form_action)
request = Net::HTTP::Post.new(url.request_uri)
request.set_form_data(request_body)
request['User-Agent'] = 'Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.5; en-US; rv:1.9.0.4) Gecko/2008102920 Firefox/3.0.4'
request['Cookie'] = COOKIE_JAR.to_cookie
request['Referer'] = internet_banking_id_url
http = Net::HTTP.new(url.host, url.port)
http.set_debug_output(debug_stream)
http.use_ssl = true
response = http.start { |http| http.request(request) }
response.to_hash['set-cookie'].each { |cookie_string| cookie_string =~ /(.*?)=(.*?);/; COOKIE_JAR[$1] = $2 }
html = response.body
File.open('3-post-internet-banking-id.txt', 'w') { |f| f.puts(debug_buffer) }
File.open('3-post-internet-banking-id.html', 'w') { |f| f.puts(html) }
doc = Hpricot(html)
html_form = doc.at('form[@action*=idv_cmd=idv.Authentication]') # We can't use the name of the form as I've seen it change
html_form_action = html_form.attributes['action']
html_form_memorable_answer_field = html_form.at('input[@name=memorableAnswer]')
html_form_password_field = html_form.at('input[@name=password]')
html_form_password_field_container = html_form_password_field.parent
digits_requested_text = html_form_password_field_container.inner_text.gsub(/\t|\n/, ' ').squeeze(' ')
digits_requested_text =~ /the (.*?) and (.*?) and (.*?) digits/i
digits_requested = [$1, $2, $3].collect { |d| d.downcase.gsub(/ /, '_') } # 'Next to Last' needs to become 'next_to_last'
digits_from_password = digits_requested.inject('') { |buffer, digit| buffer + password.send(digit) }

### POST our date of birth and password
debug_buffer = ''; debug_stream = StringIO.new(debug_buffer)
url = URI.parse(html_form_action)
request = Net::HTTP::Post.new(url.request_uri)
request.set_form_data('userid' => internet_banking_id, 'memorableAnswer' => date_of_birth, 'password' => digits_from_password) # Should be able to post hidden fields from previous form, rather than explicitly repost internet_banking_id
request['User-Agent'] = 'Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.5; en-US; rv:1.9.0.4) Gecko/2008102920 Firefox/3.0.4'
request['Cookie'] = COOKIE_JAR.to_cookie
request['Referer'] = html_form_action
http = Net::HTTP.new(url.host, url.port)
http.set_debug_output(debug_stream)
http.use_ssl = true
response = http.start { |http| http.request(request) }
response.to_hash['set-cookie'].each { |cookie_string| cookie_string =~ /(.*?)=(.*?);/; COOKIE_JAR[$1] = $2 }
html = response.body
File.open('4-post-dob-and-password.txt', 'w') { |f| f.puts(debug_buffer) }
File.open('4-post-dob-and-password.html', 'w') { |f| f.puts(html) }

### GET the javascript redirect page that contains the link we must follow to get to the statement
debug_buffer = ''; debug_stream = StringIO.new(debug_buffer)
javascript_redirect_url = response['Location']
url = URI.parse(javascript_redirect_url)
request = Net::HTTP::Get.new(url.request_uri)
request['User-Agent'] = 'Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.5; en-US; rv:1.9.0.4) Gecko/2008102920 Firefox/3.0.4'
request['Cookie'] = COOKIE_JAR.to_cookie
request['Referer'] = html_form_action
http = Net::HTTP.new(url.host, url.port)
http.set_debug_output(debug_stream)
http.use_ssl = true
response = http.start { |http| http.request(request) }
response.to_hash['set-cookie'].each { |cookie_string| cookie_string =~ /(.*?)=(.*?);/; COOKIE_JAR[$1] = $2 }
html = response.body
File.open('5-get-javascript-redirect.txt', 'w') { |f| f.puts(debug_buffer) }
File.open('5-get-javascript-redirect.html', 'w') { |f| f.puts(html) }
doc = Hpricot(html)
redirect_link = doc.at('a[@title=Click here to continue]')
redirect_link_url = redirect_link.attributes['href']

### GET the accounts overview page
debug_buffer = ''; debug_stream = StringIO.new(debug_buffer)
accounts_overview_url = 'https://www.hsbc.co.uk' + redirect_link_url # TODO: Determine the host automatically (I spent a while trying to work out what was going wrong because I'd specified http, not https)
url = URI.parse(accounts_overview_url)
request = Net::HTTP::Get.new(url.request_uri)
request['User-Agent'] = 'Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.5; en-US; rv:1.9.0.4) Gecko/2008102920 Firefox/3.0.4'
request['Cookie'] = COOKIE_JAR.to_cookie
request['Referer'] = javascript_redirect_url
http = Net::HTTP.new(url.host, url.port)
http.set_debug_output(debug_stream)
http.use_ssl = true
response = http.start { |http| http.request(request) }
response.to_hash['set-cookie'].each { |cookie_string| cookie_string =~ /(.*?)=(.*?);/; COOKIE_JAR[$1] = $2 }
html = response.body
File.open('6-get-accounts-overview.txt', 'w') { |f| f.puts(debug_buffer) }
File.open('6-get-accounts-overview.html', 'w') { |f| f.puts(html) }
doc = Hpricot(html)
submit_button_to_account_page = doc.at("form//input[@name*=#{sort_code} #{account_number}]")
form_to_account_page = submit_button_to_account_page.parent.parent
form_to_account_page_action = form_to_account_page.attributes['action']
form_to_account_page_hidden_fields = form_to_account_page.search('input[@type=hidden]')
request_body = form_to_account_page_hidden_fields.inject({}) { |hash, element| hash[element.attributes['name']] = element.attributes['value']; hash }

# POST the Recent Transactions page
debug_buffer = ''; debug_stream = StringIO.new(debug_buffer)
statement_url = 'https://www.hsbc.co.uk' + form_to_account_page_action # TODO: Determine the host automatically (I spent a while trying to work out what was going wrong because I'd specified http, not https)
url = URI.parse(statement_url)
request = Net::HTTP::Post.new(url.request_uri)
request.set_form_data(request_body)
request['User-Agent'] = 'Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.5; en-US; rv:1.9.0.4) Gecko/2008102920 Firefox/3.0.4'
request['Cookie'] = COOKIE_JAR.to_cookie
request['Referer'] = javascript_redirect_url # No it's not... (the hsbc banking web app obviously doesn't care about the referrer)
http = Net::HTTP.new(url.host, url.port)
http.set_debug_output(debug_stream)
http.use_ssl = true
response = http.start { |http| http.request(request) }
response.to_hash['set-cookie'].each { |cookie_string| cookie_string =~ /(.*?)=(.*?);/; COOKIE_JAR[$1] = $2 }
html = response.body
File.open('7-recent-transactions.txt', 'w') { |f| f.puts(debug_buffer) }
File.open('7-recent-transactions.html', 'w') { |f| f.puts(html) }
doc = Hpricot(html)
link_to_download_transactions = doc.at('a[@title*=Download the transactions]')
link_to_download_transactions_href = link_to_download_transactions.attributes['href'].strip

# GET the Download transactions page
debug_buffer = ''; debug_stream = StringIO.new(debug_buffer)
link_to_download_transactions_url = 'https://www.hsbc.co.uk' + link_to_download_transactions_href # TODO: Determine the host automatically (I spent a while trying to work out what was going wrong because I'd specified http, not https)
url = URI.parse(link_to_download_transactions_url)
request = Net::HTTP::Get.new(url.request_uri)
request['User-Agent'] = 'Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.5; en-US; rv:1.9.0.4) Gecko/2008102920 Firefox/3.0.4'
request['Cookie'] = COOKIE_JAR.to_cookie
request['Referer'] = javascript_redirect_url # No it's not... (the hsbc banking web app obviously doesn't care about the referrer)
http = Net::HTTP.new(url.host, url.port)
http.set_debug_output(debug_stream)
http.use_ssl = true
response = http.start { |http| http.request(request) }
response.to_hash['set-cookie'].each { |cookie_string| cookie_string =~ /(.*?)=(.*?);/; COOKIE_JAR[$1] = $2 }
html = response.body
File.open('8-statement-download.txt', 'w') { |f| f.puts(debug_buffer) }
File.open('8-statement-download.html', 'w') { |f| f.puts(html) }
doc = Hpricot(html)
list_of_download_types = doc.at('select#downloadType')
list_of_download_types_name = list_of_download_types.attributes['name']
list_of_download_types_ofx_option = list_of_download_types.at('option[text()=Money 98 onwards (OFX)]')
list_of_download_types_ofx_option_value = list_of_download_types_ofx_option.attributes['value']
download_transactions_form = list_of_download_types.parent.parent.parent.parent.parent # This is terrible
download_transactions_form_action = download_transactions_form.attributes['action']
request_body = {list_of_download_types_name => list_of_download_types_ofx_option_value}

# POST the statement download options (OFX format)
debug_buffer = ''; debug_stream = StringIO.new(debug_buffer)
statement_download_confirmation_url = 'https://www.hsbc.co.uk' + download_transactions_form_action # TODO: Determine the host automatically (I spent a while trying to work out what was going wrong because I'd specified http, not https)
url = URI.parse(statement_download_confirmation_url)
request = Net::HTTP::Post.new(url.request_uri)
request.set_form_data(request_body)
request['User-Agent'] = 'Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.5; en-US; rv:1.9.0.4) Gecko/2008102920 Firefox/3.0.4'
request['Cookie'] = COOKIE_JAR.to_cookie
request['Referer'] = javascript_redirect_url # No it's not... (the hsbc banking web app obviously doesn't care about the referrer)
http = Net::HTTP.new(url.host, url.port)
http.set_debug_output(debug_stream)
http.use_ssl = true
response = http.start { |http| http.request(request) }
response.to_hash['set-cookie'].each { |cookie_string| cookie_string =~ /(.*?)=(.*?);/; COOKIE_JAR[$1] = $2 }
html = response.body
File.open('9-confirm-statement-download.txt', 'w') { |f| f.puts(debug_buffer) }
File.open('9-confirm-statement-download.html', 'w') { |f| f.puts(html) }
doc = Hpricot(html)
download_statement_confirmation_form = doc.at('form[@name*=downloadForm]')
download_statement_confirmation_form_action = download_statement_confirmation_form.attributes['action']
html_form_hidden_fields = download_statement_confirmation_form.search('input[@type=hidden]')
request_body = html_form_hidden_fields.inject({}) { |hash, element| hash[element.attributes['name']] = element.attributes['value']; hash }

# POST the statement download confirmation
debug_buffer = ''; debug_stream = StringIO.new(debug_buffer)
statement_download_confirmation_url = 'https://www.hsbc.co.uk' + download_statement_confirmation_form_action # TODO: Determine the host automatically (I spent a while trying to work out what was going wrong because I'd specified http, not https)
url = URI.parse(statement_download_confirmation_url)
request = Net::HTTP::Post.new(url.request_uri)
request.set_form_data(request_body)
request['User-Agent'] = 'Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.5; en-US; rv:1.9.0.4) Gecko/2008102920 Firefox/3.0.4'
request['Cookie'] = COOKIE_JAR.to_cookie
request['Referer'] = javascript_redirect_url # No it's not... (the hsbc banking web app obviously doesn't care about the referrer)
http = Net::HTTP.new(url.host, url.port)
http.set_debug_output(debug_stream)
http.use_ssl = true
response = http.start { |http| http.request(request) }
response.to_hash['set-cookie'].each { |cookie_string| cookie_string =~ /(.*?)=(.*?);/; COOKIE_JAR[$1] = $2 }
html = response.body
File.open('10-statement.txt', 'w') { |f| f.puts(debug_buffer) }
File.open('10-statement.ofx', 'w') { |f| f.puts(html) }