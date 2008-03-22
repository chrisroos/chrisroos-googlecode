set :application, "blog.seagul.co.uk"
set :repository,  "http://chrisroos.googlecode.com/svn/trunk/migrate-typo-to-static-site"

set :deploy_to, "/home/chrisroos/www/#{application}"
set :deploy_via, :copy

role :app, "jail0093.vps.exonetric.net"
role :web, "jail0093.vps.exonetric.net"
role :db,  "jail0093.vps.exonetric.net", :primary => true

desc "Create the apache config file that allows us to actually host this site"
task :create_apache_config do
  public_directory = "#{current_path}/public"
  log_directory = "#{current_path}/log"
  template = File.open(File.join(File.dirname(__FILE__), *%w[apache.config.erb])) { |f| f.read }
  erb = ERB.new(template)
  put erb.result(binding), "#{current_path}/config/apache.config"
end