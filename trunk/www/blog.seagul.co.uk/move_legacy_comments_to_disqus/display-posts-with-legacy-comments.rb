# This little script creates an, invalid, html page containing a link to all the posts that have legacy comments.  This should make easier to check that the import has gone as planned.

require File.join(File.dirname(__FILE__), 'disqus')

html = ''

Dir[File.join(PROJECT_ROOT, 'content', 'articles', '*.yml')].each do |post_filename|
  post = YAML.load(File.read(post_filename))

  if post[:comments] && post[:comments].any?
    post_title = File.basename(post_filename, '.yml')
    
    html << %%<p><a href="http://chrisroos.co.uk/blog/#{post_title}">#{post_title} (#{post[:comments].length})</a></p>%
  end
end

File.open(File.join(File.dirname(__FILE__), 'comments.html'), 'w') { |f| f.puts(html) }