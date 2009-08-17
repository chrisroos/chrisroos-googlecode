require 'config/boot'

tasks_html = File.read(GoogleTasks::TASKS_HTML)

tasks_json = tasks_html[/_setup\((.*)\)\}<\/script>/, 1]
File.open(GoogleTasks::TASKS_JSON, 'w') { |f| f.puts(tasks_json) }