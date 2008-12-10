require File.join(File.dirname(__FILE__), 'disqus')

my_blog_forum = get_forum('deferred-until-inspiration-hits')
my_blog_forum_key = get_forum_api_key(my_blog_forum)

Dir[File.join(COMMENTS_DIR, '*.txt')].each do |comment_file|
  comment = YAML.load(File.read(comment_file))
  comment[:thread_id] = '8183514'
  
  create_comment(my_blog_forum_key, comment)
  # break
end