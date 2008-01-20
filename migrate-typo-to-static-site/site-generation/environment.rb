require 'active_record'

ActiveRecord::Base.establish_connection({
  :adapter => 'mysql',
  :host => 'localhost',
  :database => 'blog_seagul_co_uk',
  :user => 'root'
})

MIGRATOR_ROOT = File.expand_path(File.dirname(__FILE__))
SITE_ROOT = File.expand_path(File.join('..', 'Site'))