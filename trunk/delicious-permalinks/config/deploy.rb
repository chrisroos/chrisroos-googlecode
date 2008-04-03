set :application, "delicious-permalinks"
set :repository,  "http://chrisroos.googlecode.com/svn/trunk/#{application}"

set :deploy_to, "/home/chrisroos/www/#{application}"
set :deploy_via, :copy

role :app, "jail0093.vps.exonetric.net"
role :web, "jail0093.vps.exonetric.net"
role :db,  "jail0093.vps.exonetric.net", :primary => true

desc "Updates the site by svn up'ing, rather than checking out the entire site content and uploading (which deploy:update does)"
task :update_site do
  run "cd #{current_path} && svn up"
end