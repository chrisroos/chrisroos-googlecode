set :application, "delicious-permalinks"
set :repository,  "http://chrisroos.googlecode.com/svn/trunk/#{application}"

set :deploy_to, "/home/chrisroos/www/#{application}.seagul.co.uk"
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

desc "Create a symlink to the apache config so that all config files end up in the same directory which allows us to restart apache and get it to load all config files in that directory."
task :create_symlink_to_apache_config do
  run "ln -fs #{current_path}/config/apache.config #{deploy_to}.config"
end

desc "Restart the Apache webserver"
task :restart_apache do
  sudo "apachectl restart"
end

desc "Updates the site by svn up'ing, rather than checking out the entire site content and uploading (which deploy:update does)"
task :update_site do
  run "cd #{current_path} && svn up"
end