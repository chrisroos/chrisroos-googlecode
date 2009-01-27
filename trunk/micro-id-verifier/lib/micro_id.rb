$:.unshift(File.dirname(__FILE__))
$:.unshift("#{File.dirname(__FILE__)}/config")
$:.unshift("#{File.dirname(__FILE__)}/micro_id")

require 'config/database'
require 'micro_id/link'