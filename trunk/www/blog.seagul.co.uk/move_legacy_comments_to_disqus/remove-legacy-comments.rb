# This little script will remove all of the legacy comments from the posts in content/articles.  I'm safe to run this now that I've extracted, amended and uploaded all these legacy comments to disqus.

require File.join(File.dirname(__FILE__), 'disqus')

Dir[File.join(PROJECT_ROOT, 'content', 'articles', '*.yml')].each do |post_filename|
  post = YAML.load(File.read(post_filename))
  if post[:comments] && post[:comments].any?
    post.delete(:comments)
    File.open(post_filename, 'w') { |f| f.puts(post.to_yaml) }
  end
end