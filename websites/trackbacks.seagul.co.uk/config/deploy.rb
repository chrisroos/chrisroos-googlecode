default_environment['PATH'] = "/usr/local/bin:$PATH"

set :application, "trackbacks.seagul.co.uk"
set :repository,  "http://chrisroos.googlecode.com/svn/trunk/www/#{application}"

set :deploy_to, "/home/chrisroos/www/#{application}"
set :deploy_via, :copy

role :app, "jail0093.vps.exonetric.net"
role :web, "jail0093.vps.exonetric.net"
role :db,  "jail0093.vps.exonetric.net", :primary => true

desc "Start the trackback server"
task :start_trackback_server do
  run "#{current_path}/bin/trackback-server.rb"
end

task :stop_trackback_server do
  server_pid = File.join(current_path, 'log', 'trackback-server.pid')
  run "kill -KILL `cat #{server_pid}`"
  run "rm #{server_pid}"
end

desc "Clear current trackbacks"
task :clear_trackbacks do
  run "rm #{current_path}/data/trackbacks.yml"
end

# Add tasks to stop trackback server and clear trackbacks from production