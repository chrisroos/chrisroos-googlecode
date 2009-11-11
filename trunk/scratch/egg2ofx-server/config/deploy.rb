set :application, "egg2ofx-server"
set :repository,  "http://chrisroos.googlecode.com/svn/trunk/scratch/#{application}"

role :app, "seagul.co.uk"
role :web, "seagul.co.uk"
role :db,  "seagul.co.uk", :primary => true