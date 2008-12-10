require File.join(File.dirname(__FILE__), 'disqus')
require 'hpricot'

Dir[File.join(COMMENTS_DIR, '*')].each do |comment_file|
  comment = YAML.load(File.read(comment_file))
  original_message = comment[:message]
  doc = Hpricot(original_message)
  doc.search('/').collect! { |elem| elem if elem.text? }.compact.remove
  message_with_whitespace_stripped = doc.to_html
  unless original_message == message_with_whitespace_stripped
    # We've stripped some whitespace
    # Let's update the comment in the file so that disqus doesn't add a load of <br/> tags when we import them
    comment[:message] = message_with_whitespace_stripped
    File.open(comment_file, 'w') { |f| f.puts(comment.to_yaml) }
  end
end