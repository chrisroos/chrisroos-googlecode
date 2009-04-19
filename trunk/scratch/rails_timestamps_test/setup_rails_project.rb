# A simple script to test the ability to mass assign the timestamp fields (created_at, created_on, updated_at, updated_on) in various versions of rails
# To replicate, you need to create a mysql database called rails_timestamps_test (or change the details in assets/database.yml)
# The mysql database can be created with this sql
# CREATE TABLE people (id INTEGER AUTO_INCREMENT, forename VARCHAR(40), created_on DATE, created_at DATETIME, updated_on DATE, updated_at DATETIME, PRIMARY KEY (id));

# Specify the version of rails that you want to work against
RAILS_VERSION     = '2.3.0'
# Specify the location of your git cloned copy of rails (obtained with git clone git://github.com/rails/rails.git)
RAILS_GIT_REPOS   = File.join(%w(/ Users chrisroos Code third-party rails))
# Enable debugging which just displays the command being run
CMD_DEBUG         = false

# You shouldn't need to change anything below here
RAILS_CMD         = File.join(RAILS_GIT_REPOS, *%w(railties bin rails))
PROJECTS_DIR      = File.expand_path(File.join(File.dirname(__FILE__), 'projects'))
ASSETS_DIR        = File.expand_path(File.join(File.dirname(__FILE__), 'assets'))
RAILS_PROJECT_DIR = File.expand_path(File.join(PROJECTS_DIR, "rails-app-#{RAILS_VERSION.gsub(/\./, '-')}"))

def Step(msg, stars = 3)
  puts "#{'*'*stars} #{msg}"
end

def execute(cmd)
  p cmd if CMD_DEBUG
  `#{cmd}`
end

Step "Removing the rails app at #{RAILS_PROJECT_DIR}"
execute "rm -rf #{RAILS_PROJECT_DIR}"

rails_tag_label = "v#{RAILS_VERSION}"
Step "Checking out the rails version tagged #{rails_tag_label}"
execute "cd #{RAILS_GIT_REPOS} && git checkout #{rails_tag_label}"

Step "Creating the rails app at #{RAILS_PROJECT_DIR}"
execute "/usr/bin/env ruby #{RAILS_CMD} #{RAILS_PROJECT_DIR}"

Step "Vendorising rails from #{RAILS_GIT_REPOS} to #{RAILS_PROJECT_DIR}"
execute "ln -s #{RAILS_GIT_REPOS} #{File.join(RAILS_PROJECT_DIR, 'vendor', 'rails')}"

rails_app_unit_test_dir = File.join(RAILS_PROJECT_DIR, 'test', 'unit')
Step "Generating rails_version_test.rb in #{rails_app_unit_test_dir} to ensure we are testing against the correct version of rails"
require 'erb'
erb = ERB.new(DATA.read)
File.open(File.join(rails_app_unit_test_dir, 'rails_version_test.rb'), 'w') { |f| f.puts(erb.result) }

Step "Copying assets to the new rails app"
{
  'database.yml' => File.join('config'),
  'person.rb' => File.join('app', 'models'),
  'person_test.rb' => File.join('test', 'unit')
}.each do |source, target_directory|
  target = File.join(RAILS_PROJECT_DIR, target_directory, source)
  source = File.join(ASSETS_DIR, source)
  Step "Linking #{source} to #{target}", 6
  execute("ln -sf #{source} #{target}")
end

Step "Running the rails version test to ensure that we're testing against the correct version of rails"
puts execute("cd #{RAILS_PROJECT_DIR} && ruby test/unit/rails_version_test.rb")

Step "Running the timestamps test"
puts execute("cd #{RAILS_PROJECT_DIR} && ruby test/unit/person_test.rb")

__END__
require File.join(File.dirname(__FILE__), '..', 'test_helper')

class RailsVersionTest < Test::Unit::TestCase
  
  def test_should_be_using_rails_<%= RAILS_VERSION.gsub(/\./, '_') %>
    assert_equal '<%= RAILS_VERSION %>', Rails::VERSION::STRING
  end
  
end