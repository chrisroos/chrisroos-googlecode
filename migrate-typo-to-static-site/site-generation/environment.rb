require 'active_record'
require 'fileutils'

ActiveRecord::Base.establish_connection({
  :adapter => 'mysql',
  :host => 'localhost',
  :database => 'blog_seagul_co_uk',
  :user => 'root'
})

MIGRATOR_ROOT = File.expand_path(File.dirname(__FILE__))
TEMPLATE_ROOT = File.expand_path(File.join(MIGRATOR_ROOT, 'templates'))
SITE_ROOT = File.expand_path(File.join('..', 'Site'))

ARTICLES_URL_ROOT = File.join('/', 'articles')
TAGS_URL_ROOT = File.join(ARTICLES_URL_ROOT, 'tag')
PAGES_URL_ROOT = File.join('/', 'pages')