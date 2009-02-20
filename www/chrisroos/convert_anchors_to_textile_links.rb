r = /<a(.*?)>(.*?)<\/a>/

Dir[File.join(File.dirname(__FILE__), 'content', 'blog', '*.txt')].each do |filename|
  content = File.read(filename)
  if content =~ r
    puts "*** #{filename}"
    content.gsub!(r) do |m|
      anchor_attributes, anchor_text = $1, $2
      anchor_href = anchor_attributes[/href="(.*?)"/, 1]
      p [m, anchor_href, anchor_text]
      # if anchor_href =~ /^http/ # Let's only replace the http urls for now
      #   %%"#{anchor_text}":#{anchor_href}%
      # else
      #   m
      # end
    end
    # File.open(filename, 'w') { |f| f.puts(content) }
  end
end