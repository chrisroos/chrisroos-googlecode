require 'yaml'
require 'rubygems'
require 'active_record'

database_params = YAML.load(File.open("#{File.dirname(__FILE__)}/../config/database.yml"))
connection_params = database_params['database']

ActiveRecord::Base.establish_connection(connection_params)