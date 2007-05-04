require 'hsbc_credentials'

def execute_curl(cmd)
  `#{cmd}`
end

COOKIE_LOCATION = '/Users/chrisroos/hsbc_cookie'
DOWNLOADED_STATEMENT_LOCATION = '/Users/chrisroos/Desktop/statement.ofx'

class << SECURITY_CODE
  [:first, :second, :third, :fourth, :fifth, :sixth, :last].each_with_index do |method, index|
    define_method(method) do 
      method == :last ? self.split('').last : self.split('')[index]
    end
  end
end

# POST Internet Banking ID and store the cookie
# *** This doesn't actually need to be a post
# *** https://www.ebank.hsbc.co.uk/servlet/com.hsbc.ib.app.pib.logon.servlet.OnBrochurewareLogonServlet?internetBankingID=INTERNET_BANKING_ID
# *** works just fine.
curl_cmd = %[curl -s -c"#{COOKIE_LOCATION}" -L -d"internetBankingID=#{INTERNET_BANKING_ID}" "https://www.ebank.hsbc.co.uk/servlet/com.hsbc.ib.app.pib.logon.servlet.OnBrochurewareLogonServlet"]
execute_curl curl_cmd

# GET Login page so that we can work out which characters it wants
curl_cmd = %[curl -s -b"#{COOKIE_LOCATION}" "https://www.ebank.hsbc.co.uk/main/IBLogon.jsp"]
login_page = execute_curl(curl_cmd)

# p login_page[/Please enter the (.+), (.+) and (.+) digits of your security number/]
c1 = login_page[/Please enter the (.+), (.+) and (.+) digits of your security number/, 1].downcase
c2 = login_page[/Please enter the (.+), (.+) and (.+) digits of your security number/, 2].downcase
c3 = login_page[/Please enter the (.+), (.+) and (.+) digits of your security number/, 3].downcase
tsn = [c1, c2, c3].collect { |method| SECURITY_CODE.__send__(method) }.join

# POST to login now that we've (hopefully) created the tsn
curl_cmd = %[curl -s -b"#{COOKIE_LOCATION}" -L -d"dateOfBirth=#{DATE_OF_BIRTH}" -d"tsn=#{tsn}" "https://www.ebank.hsbc.co.uk/servlet/com.hsbc.ib.app.pib.logon.servlet.OnLogonVerificationServlet"]
execute_curl curl_cmd

# GET the account overview page to scrape the balance from it
curl_cmd = %[curl -s -b"#{COOKIE_LOCATION}" "https://www.ebank.hsbc.co.uk/main/portmain.jsp"]
account_overview_html = execute_curl(curl_cmd)

# Obtain and display the account balance
account_balance = account_overview_html[/<td.*?>(\d+.?\d+?\s*C|D)<\/td>/, 1]
puts account_balance

# Select my account from the list, it 'remembers' which account we've selected by using cookies, so update the cookie-jar
curl_cmd = %[curl -s -b"#{COOKIE_LOCATION}" -c"#{COOKIE_LOCATION}" -L "https://www.ebank.hsbc.co.uk/servlet/com.hsbc.ib.app.pib.accountlist.servlet.OnAccountSelectionServlet?&listID=#{SORT_CODE_AND_ACCOUNT_NUMBER}"]
execute_curl(curl_cmd)

# Download most recent transactions
curl_cmd = %[curl -s -b"#{COOKIE_LOCATION}" -d"downloadType=OFXMainstream" "https://www.ebank.hsbc.co.uk/servlet/com.hsbc.ib.app.pib.transactionhistory.servlet.DownloadServlet" -o"#{DOWNLOADED_STATEMENT_LOCATION}"]
execute_curl(curl_cmd)

puts "Statement written to #{DOWNLOADED_STATEMENT_LOCATION}."

# Remove the cookie
`rm #{COOKIE_LOCATION}`