$: << File.dirname(__FILE__)

# Start webserver
require 'micro_id_server'

micro_id_server = MicroIdServer.new
micro_id_server.start

# Validate micro_ids
require "#{File.dirname(__FILE__)}/../lib/micro_id"

puts "Good page with micro_id"
link = Link.new(:url => 'http://localhost:7000/', :expected_micro_id => 'ff511e16d7108be450fccd6f4611cf8d1d5416d1')
p link.status
link.verify_micro_id!
p link.status

puts "Non existent page"
link = Link.new(:url => 'non_existent', :expected_micro_id => 'ff511e16d7108be450fccd6f4611cf8d1d5416d1')
p link.status
link.verify_micro_id!
p link.status

puts "Good page with non existent micro_id"
link = Link.new(:url => 'http://localhost:7000/', :expected_micro_id => 'non_existent')
p link.status
link.verify_micro_id!
p link.status

# Stop webserver
micro_id_server.stop