require 'active_record'
require 'yaml'

warn "Make sure you update schema_info to 0, or drop the table, before running these migrations for the first time.  Otherwise, they just won't work..."

database_config = YAML.load_file(File.join(File.dirname(__FILE__), '..', 'config', 'database.yml'))
database_config = database_config['production']

ActiveRecord::Base.logger = Logger.new(StringIO.new)
ActiveRecord::Base.establish_connection(database_config)

ActiveRecord::Migrator.migrate(File.join(File.dirname(__FILE__), 'migrate'))