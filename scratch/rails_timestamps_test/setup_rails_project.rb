# A simple script to test the ability to mass assign the timestamp fields (created_at, created_on, updated_at, updated_on) in various versions of rails
# To replicate, you need to create a mysql database called rails_timestamps_test (or change the details in assets/database.yml)
# The mysql database can be created with this sql
# CREATE TABLE people (id INTEGER AUTO_INCREMENT, created_on DATE, created_at DATETIME, updated_on DATE, updated_at DATETIME, PRIMARY KEY (id));

if ARGV.empty?
  puts "Usage: ruby setup_rails_project.rb rails-version rails-path [debug]"
  puts ""
  puts "  - rails-version   a version of rails that corresponds to a tag in the git repos (see all tags with 'cd /path/to/rails/clone && git tag -l)"
  puts "  - rails-path      the location of your git cloned copy of rails"
  puts "  - debug           if set to true you will see the actual commands being run"
  puts ""
  puts "Example: ruby setup_rails_project.rb 2.3.0 /Users/chrisroos/Code/third-party/rails"
  puts "  where we are generating a rails app using rails 2.3.0"
  puts "  and we have previously cloned rails to /Users/chrisroos/Code/third-party/rails"
  puts "  and we don't want to see the actual commands being run"
  puts ""
  exit
end

RAILS_VERSION     = ARGV.shift
raise "You must specify the rails version you want to test against as the first argument" unless RAILS_VERSION

RAILS_GIT_REPOS   = File.expand_path(ARGV.shift) rescue nil
raise "You must specify the location of your cloned (git clone git://github.com/rails/rails.git) rails repos as the second argument" unless RAILS_GIT_REPOS

CMD_DEBUG         = ARGV.shift == 'true'

RAILS_CMD         = File.join(RAILS_GIT_REPOS, *%w(railties bin rails))
PROJECTS_DIR      = File.expand_path(File.join(File.dirname(__FILE__), 'projects'))
ASSETS_DIR        = File.expand_path(File.join(File.dirname(__FILE__), 'assets'))
RAILS_PROJECT_DIR = File.expand_path(File.join(PROJECTS_DIR, "rails-app-#{RAILS_VERSION.gsub(/\./, '-')}"))

def Step(msg, stars = 3)
  puts "#{'*'*stars} #{msg}"
end

def execute(cmd)
  puts "debug: #{cmd}" if CMD_DEBUG
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