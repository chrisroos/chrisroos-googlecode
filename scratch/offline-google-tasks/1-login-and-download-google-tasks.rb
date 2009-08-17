require 'config/boot'

# Start with a blank slate by removing the cookie jar and tasks
`rm #{GoogleTasks::COOKIE_JAR}`
`rm #{GoogleTasks::TASKS_HTML}`

# Login to google
`curl "https://www.google.com/a/#{GoogleTasks::DOMAIN}/LoginAction2" -d"Email=#{GoogleTasks::USERNAME}" -d"Passwd=#{GoogleTasks::PASSWORD}" --cookie-jar "#{GoogleTasks::COOKIE_JAR}" -L`

# Grab the tasks page
tasks_html = `curl "https://mail.google.com/tasks/a/#{GoogleTasks::DOMAIN}/ig" --cookie "#{GoogleTasks::COOKIE_JAR}" --cookie-jar "#{GoogleTasks::COOKIE_JAR}"  -L`

# Store the tasks html for later parsing
File.open(GoogleTasks::TASKS_HTML, 'w') { |f| f.puts(tasks_html) }