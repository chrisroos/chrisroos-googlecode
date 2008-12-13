require 'yaml'

POSTS_DIR  = File.join(File.dirname(__FILE__), 'content', 'articles')
OUTPUT_DIR = File.join(%w(/ Users chrisroos Code personal chrisroos www chrisroos content blog))

Dir[File.join(POSTS_DIR, '*.yml')].each do |filename|
  data = YAML.load(File.read(filename))
  
  data.merge!('filter' => ['erb', 'textile'], 'layout' => 'blog')
  data['title']      = data.delete(:title)
  data['created_at'] = data.delete(:published_at)
  data['guid']       = data.delete(:guid)
  output_filename    = File.basename(filename, '.yml')
  body               = data.delete(:body)

  File.open("#{File.join(OUTPUT_DIR, output_filename)}.txt", 'w') do |f|
    f.puts(data.to_yaml)
    f.puts('---')
    f.puts(body)
  end
end