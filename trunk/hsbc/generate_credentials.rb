credentials = {}

print "Enter your Sort Code: "
credentials['sort_code'] = gets.chomp

print "Enter your Account Number: "
credentials['account_number'] = gets.chomp

print "Enter your Internet Banking Id: "
credentials['internet_banking_id'] = gets.chomp

print "Enter your Date of Birth (ddmmyy): "
credentials['date_of_birth'] = gets.chomp

print "Enter your security code: "
credentials['password'] = gets.chomp

require 'yaml'

File.open('hsbc_credentials.yml', 'w') { |f| f.puts(credentials.to_yaml) }
puts "Credentials stored in hsbc_credentials.yml.  I'd strongly recommend encrypting this file."
