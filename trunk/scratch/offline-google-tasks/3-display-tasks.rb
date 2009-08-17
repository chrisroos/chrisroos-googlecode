require 'config/boot'

tasks = JSON.load(File.read(GoogleTasks::TASKS_JSON))
tasks['t']['tasks'].each do |task|
  p task['name']
end