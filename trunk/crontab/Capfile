desc 'Update crontab'
task :deploy, :hosts => 'seagul.co.uk' do
  upload 'crontab.txt', '/home/chrisroos/tmp/crontab.txt'
  run "crontab /home/chrisroos/tmp/crontab.txt"
end