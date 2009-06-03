set :application, "deliciolytics.co.uk"
set :repository,  "http://chrisroos.googlecode.com/svn/trunk/scratch/#{application}"

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
# set :scm, :subversion

role :app, "seagul.co.uk"
role :web, "seagul.co.uk"
role :db,  "seagul.co.uk", :primary => true

after 'deploy:update_code', 'symlink:db'
after 'deploy:setup', 'filesystem:create_shared_directories'

namespace :filesystem do
  desc 'Create the directories required for the app to function correctly'
  task :create_shared_directories do
    run "mkdir #{File.join(shared_path, 'config')}"
  end
end

namespace :symlink do
  desc "symlink database yaml" 
  task :db do
    run "ln -s #{shared_path}/config/database.yml #{release_path}/config/database.yml" 
  end
end

namespace :deploy do

  desc "Restart Application"
  task :restart do
    run "touch #{current_path}/tmp/restart.txt"
  end
  
  [:start, :stop].each do |t|
    desc "#{t} task is a no-op with mod_rails"
    task t, :roles => :app do ; end
  end
  
end