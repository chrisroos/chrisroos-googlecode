require 'yaml'

Dir[File.join(File.dirname(__FILE__), 'content', 'articles', '*.yml')].each do |post_file|
  post = YAML.load(File.read(post_file))
  if post[:comments]
    post.delete(:comments)
    File.open(post_file, 'w') { |f| f.puts(post.to_yaml) }
  end
end