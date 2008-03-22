set :application, "thisiskent.seagul.co.uk"
set :repository,  "http://chrisroos.googlecode.com/svn/trunk/thisis-rss"

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

desc "Create a symlink to the apache config so that all config files end up in the same directory which allows us to restart apache and get it to load all config files in that directory."
task :create_symlink_to_apache_config do
  run "ln -s #{current_path}/config/apache.config #{deploy_to}.config"
end

desc "Upload data/articles.yaml and public/news.atom from the local working directory.  I used this when copying the data from one server to another (downloaded it first, obviously)."
task :upload_data_and_feed do
  data = File.open(File.join(File.dirname(__FILE__), *%w[.. data articles.yaml])) { |f| f.read }
  feed = File.open(File.join(File.dirname(__FILE__), *%w[.. public news.atom])) { |f| f.read }
  put data, "#{current_path}/data/articles.yaml"
  put feed, "#{current_path}/public/news.atom"
end

desc "Restart the Apache webserver"
task :restart_apache do
  sudo "apachectl restart"
end

desc "Install the crontab (this will overwrite any existing crontabs installed so be careful)"
task :install_crontab do
  template = File.open(File.join(File.dirname(__FILE__), *%w[cron.config.erb])) { |f| f.read }
  erb = ERB.new(template)
  put erb.result(binding), "#{current_path}/config/cron.config"
  run "crontab #{current_path}/config/cron.config"
end