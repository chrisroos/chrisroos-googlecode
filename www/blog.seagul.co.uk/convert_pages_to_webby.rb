require 'yaml'

OUTPUT_DIR = ARGV.shift
raise "Please specify the directory that these pages should be written to" unless OUTPUT_DIR

PAGES_DIR = File.join(File.dirname(__FILE__), 'content', 'pages')

Dir[File.join(PAGES_DIR, '*.yml')].each do |page_filename|
  page_data = YAML.load(File.read(page_filename))
  
  page_data.merge!('filter' => ['erb', 'textile'])
  page_data['title']      = page_data.delete(:title)
  page_data['created_at'] = page_data.delete(:created_at)
  output_filename         = page_data.delete(:name)
  body                    = page_data.delete(:body)

  File.open("#{File.join(OUTPUT_DIR, output_filename)}.txt", 'w') do |f|
    f.puts(page_data.to_yaml)
    f.puts('---')
    f.puts(body)
  end
end