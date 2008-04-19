set :application, "public-swimming-pools.co.uk"
set :repository,  "http://chrisroos.googlecode.com/svn/trunk/www/#{application}"

if ENV['HOSTS'] == 'localhost'
  set :domain, application.gsub(/\.co\.uk$/, '.local')
else
  set :domain, application
end

set :deploy_to, "/u/chrisroos/www/#{domain}"
set :deploy_via, :copy

role :app, "jail0093.vps.exonetric.net"
role :web, "jail0093.vps.exonetric.net"
role :db,  "jail0093.vps.exonetric.net", :primary => true