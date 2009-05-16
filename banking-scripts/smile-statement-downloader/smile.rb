require 'hpricot'

class SecurityCode < String
  [:first, :second, :third, :fourth].each_with_index do |method_name, index|
    define_method(method_name) { self[index].chr }
  end
end

require File.join(File.dirname(__FILE__), 'security_details')

def cookie_path
  File.join(File.dirname(__FILE__), 'cookies', 'smile.cookie')
end

def pages_path(page_name)
  File.join(File.dirname(__FILE__), 'pages', page_name)
end

def smile_domain
  'https://welcome23.smile.co.uk'
end

#*** Start page
start_page = `curl "#{smile_domain}/SmileWeb/start.do" -c"#{cookie_path}"`
File.open(pages_path('start_page.html'), 'w') { |f| f.puts(start_page) }
doc = Hpricot(start_page)
token = (doc/'form'/'input[@name=org.apache.struts.taglib.html.TOKEN]').first.attributes['value']

#*** Security number page
security_number_page = `curl "#{smile_domain}/SmileWeb/login.do" \
-d"org.apache.struts.taglib.html.TOKEN=#{token}" \
-d"sortCode=#{SecurityDetails['sortCode']}" \
-d"accountNumber=#{SecurityDetails['accountNumber']}" \
-b"#{cookie_path}"` 
File.open(pages_path('security-number-page.html'), 'w') { |f| f.puts(security_number_page) }
doc = Hpricot(security_number_page)
first_passcode_digit = (doc/'label[@for=firstPassCodeDigit]').inner_text.split(' ').first
second_passcode_digit = (doc/'label[@for=secondPassCodeDigit]').inner_text.split(' ').first
first_security_digit = SecurityDetails['securityCode'].__send__(first_passcode_digit)
second_security_digit = SecurityDetails['securityCode'].__send__(second_passcode_digit)
token = (doc/'form'/'input[@name=org.apache.struts.taglib.html.TOKEN]').first.attributes['value']

curl_cmd = %%curl "#{smile_domain}/SmileWeb/passcode.do" \
-d"org.apache.struts.taglib.html.TOKEN=#{token}" \
-d"firstPassCodeDigit=#{first_security_digit}" \
-d"secondPassCodeDigit=#{second_security_digit}" \
-b"#{cookie_path}"%
security_question_page = `#{curl_cmd}` 
File.open(pages_path('security-question-page.html'), 'w') { |f| f.puts(security_question_page) }
doc = Hpricot(security_question_page)
question = (doc/'form'/'input[@type=password]').first.attributes['name']
token = (doc/'form'/'input[@name=org.apache.struts.taglib.html.TOKEN]').first.attributes['value']

curl_cmd = %%curl "#{smile_domain}/SmileWeb/loginSpi.do" \
-d"org.apache.struts.taglib.html.TOKEN=#{token}" \
-b"#{cookie_path}"%
if question == 'memorableDay'
  memorableday, memorablemonth, memorableyear = SecurityDetails['memorabledate']
  curl_cmd << %% -d"memorableDay=#{memorableday}"%
  curl_cmd << %% -d"memorableMonth=#{memorablemonth}"%
  curl_cmd << %% -d"memorableYear=#{memorableyear}"%
else
  answer = SecurityDetails[question]
  curl_cmd << %% -d"#{question}=#{answer}"%
end
puts curl_cmd
accounts_overview_page = `#{curl_cmd}`
File.open(pages_path('accounts-overview.html'), 'w') { |f| f.puts(accounts_overview_page) }
doc = Hpricot(accounts_overview_page)
current_account_url = (doc/'a[@title=click here to go to recent items]').first.attributes['href']

curl_cmd = %%curl "#{smile_domain}#{current_account_url}" \
-b"#{cookie_path}"% 
current_account_overview_page = `#{curl_cmd}`
File.open(pages_path('current-account-overview.html'), 'w') { |f| f.puts(current_account_overview_page) }
