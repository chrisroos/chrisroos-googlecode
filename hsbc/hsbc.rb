require 'hsbc_credentials'

COOKIE_LOCATION = '/Users/chrisroos/hsbc_cookie'

class << SECURITY_CODE
  [:first, :second, :third, :fourth, :fifth, :sixth, :last].each_with_index do |method, index|
    define_method(method) do 
      method == :last ? self.split('').last : self.split('')[index]
    end
  end
end

# POST Internet Banking ID and store the cookie
curl_cmd = %[curl -s -c"#{COOKIE_LOCATION}" -L -d"internetBankingID=#{INTERNET_BANKING_ID}" "https://www.ebank.hsbc.co.uk/servlet/com.hsbc.ib.app.pib.logon.servlet.OnBrochurewareLogonServlet"]
`#{curl_cmd}`

# GET Login page so that we can work out which characters it wants
curl_cmd = %[curl -s -b"#{COOKIE_LOCATION}" "https://www.ebank.hsbc.co.uk/main/IBLogon.jsp"]
login_page = `#{curl_cmd}`

# p login_page[/Please enter the (.+), (.+) and (.+) digits of your security number/]
c1 = login_page[/Please enter the (.+), (.+) and (.+) digits of your security number/, 1].downcase
c2 = login_page[/Please enter the (.+), (.+) and (.+) digits of your security number/, 2].downcase
c3 = login_page[/Please enter the (.+), (.+) and (.+) digits of your security number/, 3].downcase
tsn = [c1, c2, c3].collect { |method| SECURITY_CODE.__send__(method) }.join
# p tsn

# POST to login now that we've (hopefully) created the tsn
curl_cmd = %[curl -s -b"#{COOKIE_LOCATION}" -L -d"dateOfBirth=#{DATE_OF_BIRTH}" -d"tsn=#{tsn}" "https://www.ebank.hsbc.co.uk/servlet/com.hsbc.ib.app.pib.logon.servlet.OnLogonVerificationServlet"]
`#{curl_cmd}`

# GET the account overview page to scrape the balance from it
curl_cmd = %[curl -s -b"#{COOKIE_LOCATION}" "https://www.ebank.hsbc.co.uk/main/portmain.jsp"]
account_overview_html = `#{curl_cmd}`

# Remove the cookie
`rm #{COOKIE_LOCATION}`

# Obtain and display the account balance
account_balance = account_overview_html[/<td.*?>(\d+.?\d+?\s*C|D)<\/td>/, 1]
puts account_balance