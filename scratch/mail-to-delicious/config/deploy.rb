set :application, "mail-to-delicious"
set :repository,  "http://chrisroos.googlecode.com/svn/trunk/scratch/mail-to-delicious"

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
set :deploy_to, "/home/chrisroos/apps/#{application}"

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
# set :scm, :subversion

role :app, "seagul.co.uk"
role :web, "seagul.co.uk"
role :db,  "seagul.co.uk", :primary => true

after "deploy:update" do
  run "ln -s #{File.join(deploy_to, shared_dir, 'config', 'delicious.yml')} #{File.join(deploy_to, current_dir, 'config', 'delicious.yml')}"
end