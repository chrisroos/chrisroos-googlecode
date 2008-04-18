set :application, "delicious-permalinks"
set :repository,  "http://chrisroos.googlecode.com/svn/trunk/#{application}"

set :deploy_to, "/home/chrisroos/www/#{application}.seagul.co.uk"
set :deploy_via, :copy

role :app, "jail0093.vps.exonetric.net"
role :web, "jail0093.vps.exonetric.net"
role :db,  "jail0093.vps.exonetric.net", :primary => true