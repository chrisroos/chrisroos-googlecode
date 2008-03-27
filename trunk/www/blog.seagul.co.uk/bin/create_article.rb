#! /usr/bin/env ruby

require File.join(File.dirname(__FILE__), *%w[.. config environment])
require File.join(File.dirname(__FILE__), *%w[.. site-generation models article])
require File.join(File.dirname(__FILE__), *%w[.. vendor uuidtools])

published_at = Time.now
guid = UUID.random_create.to_s

title = ARGV[0]
raise "You must supply the title of the article as the first, and only, argument" unless title

filename = Article.new(:title => title).permalink
filepath = File.join(File.dirname(__FILE__), '..', 'articles', "#{filename}.rb")

if File.exists?(filepath)
  warn "WARNING: Cannot overwrite existing article called: #{filename}.rb"
else
  File.open(filepath, 'w') do |file|
    file.puts(published_at)
    file.puts(guid)
  end
  puts "Created article: #{filename}.rb"
end