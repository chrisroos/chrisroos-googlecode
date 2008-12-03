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

class Client
  
  UserAgent = 'Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.5; en-US; rv:1.9.0.4) Gecko/2008102920 Firefox/3.0.4'
  
  def initialize(debug = false)
    @debug = debug
    @cookie_jar = CookieJar.new
    initialize_debug_buffer
  end
  
  def get(url)
    uri = URI.parse(url)
    request = initialize_get_request(uri)
    send_the_request(uri, request)
  end
  
  def post(url, data)
    uri = URI.parse(url)
    request = initialize_post_request(uri, data)
    send_the_request(uri, request)
  end
  
  def write_debug_data(io)
    io.puts(debug_buffer)
  end
  
  private
  
    attr_reader :debug_stream, :debug_buffer, :cookie_jar
  
    def initialize_debug_buffer
      @debug_buffer = '';
      @debug_stream = StringIO.new(@debug_buffer)
    end
    
    def send_the_request(uri, request)
      http = initialize_http(uri)
      response = http.start { |http| http.request(request) }
      store_the_cookies(response)
      return get(response['Location']) if response.code == '302'
      response
    end
    
    def store_the_cookies(response)
      response.to_hash['set-cookie'].each { |cookie_string| cookie_string =~ /(.*?)=(.*?);/; cookie_jar[$1] = $2 }
    end
    
    def initialize_get_request(url)
      request = Net::HTTP::Get.new(url.request_uri)
      return request_with_defaults_set(request)
    end
    
    def initialize_post_request(url, data)
      request = Net::HTTP::Post.new(url.request_uri)
      request.set_form_data(data)
      return request_with_defaults_set(request)
    end
    
    def request_with_defaults_set(request)
      request['User-Agent'] = UserAgent
      request['Cookie'] = cookie_jar.to_cookie
      request
    end
    
    def initialize_http(url)
      http = Net::HTTP.new(url.host, url.port)
      http.set_debug_output(debug_stream) if debug?
      http.use_ssl = true if url.scheme == 'https'
      http
    end
    
    def debug?
      @debug
    end
  
    class CookieJar < Hash
      def to_cookie
        collect { |key, value| "#{key}=#{value}" }.join(';')
      end
    end
end

client = Client.new

### GET the homepage so that we can get the url (including jsessionid) of the page that asks for our internet banking id
homepage_url = 'http://www.hsbc.co.uk/1/2/'
html = client.get(homepage_url).body
File.open('1-get-homepage.html', 'w') { |f| f.puts(html) }
doc = Hpricot(html)
link_to_personal_banking_login_page = doc.at('a[@href*=HSBCINTEGRATION]')
link_to_personal_banking_login_page_href = link_to_personal_banking_login_page.attributes['href']

### GET the page that asks for our internet banking id
internet_banking_id_url = 'http://www.hsbc.co.uk' + link_to_personal_banking_login_page_href
html = client.get(internet_banking_id_url).body
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
html = client.post(html_form_action, request_body).body
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

### POST our date of birth and password, and auto follow the redirect to the page that contains a javascript redirect
response = client.post(html_form_action, 'userid' => internet_banking_id, 'memorableAnswer' => date_of_birth, 'password' => digits_from_password) # Should be able to post hidden fields from previous form, rather than explicitly repost internet_banking_id
html = response.body
File.open('4-post-dob-and-password.html', 'w') { |f| f.puts(html) }
doc = Hpricot(html)
redirect_link = doc.at('a[@title=Click here to continue]')
redirect_link_url = redirect_link.attributes['href']

### GET the accounts overview page
accounts_overview_url = 'https://www.hsbc.co.uk' + redirect_link_url # TODO: Determine the host automatically (I spent a while trying to work out what was going wrong because I'd specified http, not https)
html = client.get(accounts_overview_url).body
File.open('6-get-accounts-overview.html', 'w') { |f| f.puts(html) }
doc = Hpricot(html)
submit_button_to_account_page = doc.at("form//input[@name*=#{sort_code} #{account_number}]")
form_to_account_page = submit_button_to_account_page.parent.parent
form_to_account_page_action = form_to_account_page.attributes['action']
form_to_account_page_hidden_fields = form_to_account_page.search('input[@type=hidden]')
request_body = form_to_account_page_hidden_fields.inject({}) { |hash, element| hash[element.attributes['name']] = element.attributes['value']; hash }

# POST the Recent Transactions page
statement_url = 'https://www.hsbc.co.uk' + form_to_account_page_action # TODO: Determine the host automatically (I spent a while trying to work out what was going wrong because I'd specified http, not https)
html = client.post(statement_url, request_body).body
File.open('7-recent-transactions.html', 'w') { |f| f.puts(html) }
doc = Hpricot(html)
link_to_download_transactions = doc.at('a[@title*=Download the transactions]')
link_to_download_transactions_href = link_to_download_transactions.attributes['href'].strip

# GET the Download transactions page
link_to_download_transactions_url = 'https://www.hsbc.co.uk' + link_to_download_transactions_href # TODO: Determine the host automatically (I spent a while trying to work out what was going wrong because I'd specified http, not https)
html = client.get(link_to_download_transactions_url).body
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
statement_download_confirmation_url = 'https://www.hsbc.co.uk' + download_transactions_form_action # TODO: Determine the host automatically (I spent a while trying to work out what was going wrong because I'd specified http, not https)
html = client.post(statement_download_confirmation_url, request_body).body
File.open('9-confirm-statement-download.html', 'w') { |f| f.puts(html) }
doc = Hpricot(html)
download_statement_confirmation_form = doc.at('form[@name*=downloadForm]')
download_statement_confirmation_form_action = download_statement_confirmation_form.attributes['action']
html_form_hidden_fields = download_statement_confirmation_form.search('input[@type=hidden]')
request_body = html_form_hidden_fields.inject({}) { |hash, element| hash[element.attributes['name']] = element.attributes['value']; hash }

# POST the statement download confirmation
statement_download_confirmation_url = 'https://www.hsbc.co.uk' + download_statement_confirmation_form_action # TODO: Determine the host automatically (I spent a while trying to work out what was going wrong because I'd specified http, not https)
ofx = client.post(statement_download_confirmation_url, request_body).body
File.open('statement.ofx', 'w') { |f| f.puts(ofx) }

# Output the debug log
File.open('client-debug.txt', 'w') { |f| client.write_debug_data(f) }