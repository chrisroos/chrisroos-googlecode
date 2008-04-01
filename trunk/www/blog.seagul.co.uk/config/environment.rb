require 'active_record'
require 'fileutils'

PROJECT_ROOT = File.expand_path(File.join(File.dirname(__FILE__), '..'))

MIGRATOR_ROOT = File.join(PROJECT_ROOT, 'site-generation')
TEMPLATE_ROOT = File.join(MIGRATOR_ROOT, 'templates')
SITE_ROOT = File.join(PROJECT_ROOT, 'public')

ARTICLES_URL_ROOT = File.join('/', 'articles')
TAGS_URL_ROOT = File.join(ARTICLES_URL_ROOT, 'tag')
PAGES_URL_ROOT = File.join('/', 'pages')

$: << File.join(MIGRATOR_ROOT, 'models')
$: << File.join(MIGRATOR_ROOT, 'lib')

database_config = YAML.load_file(File.join(File.dirname(__FILE__), 'database.yml'))
database_config = database_config['production']

# ActiveRecord::Base.establish_connection(database_config)
# ActiveRecord::Base.logger = Logger.new(StringIO.new)