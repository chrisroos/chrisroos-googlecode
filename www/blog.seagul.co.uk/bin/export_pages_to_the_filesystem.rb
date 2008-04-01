require File.join(File.dirname(__FILE__), *%w[.. config environment])
require 'page'

Page.find(:all).each do |page|
  page_attributes = page.attributes.symbolize_keys
  page_attributes.delete(:id)
  created_at_for_filename = page_attributes[:created_at].strftime("%Y-%m-%d")
  filename = "#{created_at_for_filename}-#{page.name}.yml"
  filepath = File.join(File.dirname(__FILE__), '..', 'content', 'pages', filename)

  if File.exists?(filepath)
    warn "WARNING: Cannot overwrite existing page called: #{filename}"
  else
    File.open(filepath, 'w') { |f| f.puts(page_attributes.to_yaml) }
    puts "Created page: #{filename}"
  end
end