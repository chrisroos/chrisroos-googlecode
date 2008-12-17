Dir[File.join(File.dirname(__FILE__), 'content', 'blog', '*.txt')].each do |file|
  data = File.read(file)
  if data =~ Regexp.new(Regexp.escape('blog.seagul.co.uk/articles/'))
    data.gsub!(/http:\/\/blog\.seagul\.co\.uk\/articles\/(\d{4})\/(\d{2})\/(\d{2})\/(.*?) /) do |m|
      "/blog/#{$1}-#{$2}-#{$3}-#{$4} "
    end
    File.open(file, 'w') { |f| f.puts(data) }
  end
end