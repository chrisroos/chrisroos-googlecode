set :application, "egg2ofx-server"
set :repository,  "http://chrisroos.googlecode.com/svn/trunk/scratch/#{application}"

role :app, "seagul.co.uk"
role :web, "seagul.co.uk"
role :db,  "seagul.co.uk", :primary => true

after 'deploy:update_code', 'bundler:rebundle'

namespace :deploy do
  task :start do; end
  task :stop do; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{File.join(current_path, 'tmp', 'restart.txt')}"
  end
end

namespace :bundler do
  desc "run gem bundler"
  task :rebundle do
    # run "cd #{release_path} && gem bundle --cached"
    puts "I haven't got to work automatically yet.  For now, change into the new release directory and run:"
    puts "$ sudo gem bundle"
    puts "We need to use sudo because otherwise hpricot doesn't install."
  end
end