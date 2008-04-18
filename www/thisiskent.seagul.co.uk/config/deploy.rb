set :application, "thisiskent.seagul.co.uk"
set :repository,  "http://chrisroos.googlecode.com/svn/trunk/www/thisiskent.seagul.co.uk"

set :deploy_to, "/home/chrisroos/www/#{application}"
set :deploy_via, :copy

role :app, "jail0093.vps.exonetric.net"
role :web, "jail0093.vps.exonetric.net"
role :db,  "jail0093.vps.exonetric.net", :primary => true

desc "Upload data/articles.yaml and public/news.atom from the local working directory.  I used this when copying the data from one server to another (downloaded it first, obviously)."
task :upload_data_and_feed do
  data = File.open(File.join(File.dirname(__FILE__), *%w[.. data articles.yaml])) { |f| f.read }
  feed = File.open(File.join(File.dirname(__FILE__), *%w[.. public news.atom])) { |f| f.read }
  put data, "#{current_path}/data/articles.yaml"
  put feed, "#{current_path}/public/news.atom"
end

desc "Install the crontab (this will overwrite any existing crontabs installed so be careful)"
task :install_crontab do
  template = File.open(File.join(File.dirname(__FILE__), *%w[cron.config.erb])) { |f| f.read }
  erb = ERB.new(template)
  put erb.result(binding), "#{current_path}/config/cron.config"
  run "crontab #{current_path}/config/cron.config"
end