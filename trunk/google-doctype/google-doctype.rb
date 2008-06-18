#! /usr/bin/env ruby

require File.join(File.dirname(__FILE__), 'moin_moin_wiki_page_creator')
require File.join(File.dirname(__FILE__), 'google-wiki-convertor')

google_doctype_wiki_directory = ARGV.shift
raise "Please specify the location of the google-doctype wiki directory" unless google_doctype_wiki_directory

moinmoin_wiki_pages_directory = ARGV.shift
raise "Please specify the location of the MoinMoin wiki directory (e.g. moinmoin/wiki/data/pages)" unless moinmoin_wiki_pages_directory

convertor = GoogleWikiConvertor.new

# Let's copy the Welcome page (default google wiki page) to the FrontPage (default moinmoin wiki page) so that we are presented with google doctype as soon we visit the moinmoin wiki
FileUtils.cp(File.join(google_doctype_wiki_directory, 'Welcome.wiki'), File.join(google_doctype_wiki_directory, 'FrontPage.wiki'))

Dir[File.join(google_doctype_wiki_directory, '*.wiki')].each do |wiki_file|
  puts "Creating page for #{File.basename(wiki_file)}"
  MoinMoinWikiPageCreator.new(wiki_file, moinmoin_wiki_pages_directory, convertor).create 
end
