# forums (my blog) / threads (each post) / posts (each comment)

require 'disqus_user_api_key' # This defines the USER_API_KEY and MUST NOT BE committed

DISQUS_API    = 'http://disqus.com/api'

PROJECT_ROOT  = File.join(File.dirname(__FILE__), '..')
THREADS_FILE  = File.join(File.dirname(__FILE__), 'threads.yml')
COMMENTS_DIR  = File.join(File.dirname(__FILE__), 'comments')

def curl(cmd)
  cmd = "curl #{cmd} -s"
  # puts cmd
  `#{cmd}`
end
  
require 'json'
require 'yaml'

def get_forums
  puts "Getting all forums"
  forums_json = curl %%"#{DISQUS_API}/get_forum_list/?user_api_key=#{USER_API_KEY}"%
  forums = JSON.parse(forums_json)
end

def get_forum(short_name)
  forums = get_forums
  puts "Getting forum with short name: #{short_name}"
  forums['message'].find { |f| f['shortname'] == short_name }
end

def get_forum_api_key(forum)
  forum_id = forum['id']
  puts "Getting key for forum_id: #{forum_id}"
  forum_api_key_json = curl %%"#{DISQUS_API}/get_forum_api_key/?user_api_key=#{USER_API_KEY}&forum_id=#{forum_id}"%
  JSON.parse(forum_api_key_json)['message']
end

def get_all_threads(forum_key)
  puts "Getting all threads (posts) for forum with key: #{forum_key}"
  threads_json = curl %%"#{DISQUS_API}/get_thread_list/?forum_api_key=#{forum_key}"%
  JSON.parse(threads_json)['message']
end

def store_threads(threads)
  puts "Storing threads to: #{THREADS_FILE}"
  File.open(THREADS_FILE, 'w') { |f| f.puts(threads.to_yaml) }
end