require File.join(File.dirname(__FILE__), '..', 'config', 'environment')
require 'active_record'
require 'yaml'

warn "Make sure you update schema_info to 0, or drop the table, before running these migrations for the first time.  Otherwise, they just won't work..."

ActiveRecord::Migrator.migrate(File.join(File.dirname(__FILE__), 'migrate'))