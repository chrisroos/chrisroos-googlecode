after :deploy, 'apache:restart'

desc 'Copy the config files to the server using rsync'
task :deploy do
  system "rsync -av *.config chrisroos@seagul.co.uk:/home/chrisroos/www-config/"
end

namespace :apache do
  desc 'Restart apache'
  task :restart, :hosts => 'seagul.co.uk' do
    sudo 'apachectl restart'
  end
end