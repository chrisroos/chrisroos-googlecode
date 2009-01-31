require 'rubygems'
require 'cgi'
require 'time'
require 'hmac'
require 'hmac-sha2'
require 'base64'

require File.join(File.dirname(__FILE__), 'amazon-sdb-credentials')

AMAZON_ENDPOINT = 'https://sdb.amazonaws.com/'

params = {
  'Action' => 'ListDomains',
  'AWSAccessKeyId' => ACCESS_IDENTIFIER,
  'SignatureMethod' => 'HmacSHA256',
  'SignatureVersion' => 2,
  'Timestamp' => Time.now.iso8601,
  'Version' => '2007-11-07'
}

canonical_querystring = params.sort.collect { |key, value| [CGI.escape(key.to_s), CGI.escape(value.to_s)].join('=') }.join('&')
string_to_sign = "GET
sdb.amazonaws.com
/
#{canonical_querystring}"
                                
hmac = HMAC::SHA256.new(SECRET_IDENTIFIER)
hmac.update(string_to_sign)
signature = Base64.encode64(hmac.digest).chomp # chomp is important!  the base64 encoded version will have a newline at the end

params['Signature'] = signature
querystring = params.collect { |key, value| [CGI.escape(key.to_s), CGI.escape(value.to_s)].join('=') }.join('&') # order doesn't matter for the actual request

puts `curl -X"GET" "#{AMAZON_ENDPOINT}?#{querystring}" -A"simple ruby aws sdb wrapper"`