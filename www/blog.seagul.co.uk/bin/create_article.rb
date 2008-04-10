#! /usr/bin/env ruby

title = ARGV.delete_at(0)
raise "You must supply the title of the article as the first, and only, argument" unless title

force_creation = ARGV.delete_at(0) || false

body = ''
while line = gets
  body << line
end

require File.join(File.dirname(__FILE__), *%w[.. config environment])
require File.join(File.dirname(__FILE__), *%w[.. site-generation models article])
require File.join(File.dirname(__FILE__), *%w[.. vendor uuidtools])

published_at = Time.now
published_at_for_filename = published_at.strftime("%Y-%m-%d")
guid = UUID.random_create.to_s

permalink = Article.new(:title => title).permalink
filename = "#{published_at_for_filename}-#{permalink}.yml"
filepath = File.join(File.dirname(__FILE__), '..', 'content', 'articles', filename)

if File.exists?(filepath) && !force_creation
  warn "WARNING: Cannot overwrite existing article called: #{filename}"
else
  article_data = {
    :title => title,
    :published_at => published_at,
    :guid => guid,
    :body => body
  }
  File.open(filepath, 'w') { |file| file.puts(article_data.to_yaml) }
  puts "Created article: #{filename}.rb"
end