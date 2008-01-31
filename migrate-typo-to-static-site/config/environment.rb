require 'active_record'
require 'fileutils'

ActiveRecord::Base.establish_connection({
  :adapter => 'mysql',
  :host => 'localhost',
  :database => 'blog_seagul_co_uk',
  :user => 'root'
})

PROJECT_ROOT = File.expand_path(File.join(File.dirname(__FILE__), '..'))

MIGRATOR_ROOT = File.join(PROJECT_ROOT, 'site-generation')
TEMPLATE_ROOT = File.join(MIGRATOR_ROOT, 'templates')
SITE_ROOT = File.join(PROJECT_ROOT, 'Site')

ARTICLES_URL_ROOT = File.join('/', 'articles')
TAGS_URL_ROOT = File.join(ARTICLES_URL_ROOT, 'tag')
PAGES_URL_ROOT = File.join('/', 'pages')

$: << File.join(MIGRATOR_ROOT, 'models')
$: << File.join(MIGRATOR_ROOT, 'lib')