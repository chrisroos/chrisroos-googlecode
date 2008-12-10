# Create a list of all the threads/posts on my blogs that can contain comments.  I'll need to look these up in order to assign the correct thread_id to my legacy comments.

require File.join(File.dirname(__FILE__), 'disqus')

my_blog_forum = get_forum('deferred-until-inspiration-hits')
my_blog_forum_key = get_forum_api_key(my_blog_forum)
threads = get_all_threads(my_blog_forum_key)
store_threads(threads)