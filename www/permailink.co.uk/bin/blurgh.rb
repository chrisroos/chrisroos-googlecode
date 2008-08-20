$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'pop_ssl' # I renamed the file from pop.rb to pop_ssl.rb to ensure I was requiring the correct version
require File.join(File.dirname(__FILE__), '..', 'config', 'credentials')

require 'yaml'

Net::POP3.enable_ssl(OpenSSL::SSL::VERIFY_NONE)
pop3 = Net::POP3.new('pop.gmail.com', 995)
pop3.open_timeout = 120
pop3.start(USERNAME, PASSWORD) do |pop|
  if pop.mails.empty?
    puts 'No mail.'
  else
    pop.each_mail do |mail|
      body = mail.pop
      id = mail.unique_id
      File.open(File.join('emails', "#{id}"), 'w') { |f| f.puts(body) }
    end
  end
end
