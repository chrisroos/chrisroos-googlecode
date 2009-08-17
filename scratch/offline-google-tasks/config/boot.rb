require 'yaml'
require 'cgi'
require 'rubygems'
require 'json'

module GoogleTasks
  
  PROJECT_ROOT  = File.expand_path(File.join(File.dirname(__FILE__), '..'))
  
  SETTINGS_FILE = File.join(PROJECT_ROOT, 'config', 'settings.yml')
  COOKIE_JAR    = File.join(PROJECT_ROOT, 'tmp', 'cookies.txt')
  TASKS_HTML    = File.join(PROJECT_ROOT, 'tmp', 'tasks.html')
  TASKS_JSON    = File.join(PROJECT_ROOT, 'tmp', 'tasks.json')
  
  SETTINGS      = YAML.load(File.read(SETTINGS_FILE))
  USERNAME      = CGI.escape(SETTINGS[:username])
  PASSWORD      = CGI.escape(SETTINGS[:password])
  DOMAIN        = SETTINGS[:domain]
  
end unless defined?(GoogleTasks)