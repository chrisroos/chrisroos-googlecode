#! /usr/bin/env ruby

require File.join(File.dirname(__FILE__), *%w[.. config environment])
require 'article'

filename = ARGV.delete_at(0)
raise "You must specify the filename of the article to delete" unless filename

article_data = YAML.load_file(filename)
Article.find_by_guid(article_data[:guid]).destroy

FileUtils.rm(filename)