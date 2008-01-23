#! /usr/bin/env ruby
# 
# while line = gets
#   # puts line[/href="(http:\/\/blog\.seagul\.co\.uk.*?)"/, 1]
#   puts line[/span class="a">/m]
# end

google_serp = ARGV[0]
raise "Please supply the filename of the google SERP you wish to parse as the first argument" if google_serp.nil? or google_serp.empty?

require 'hpricot'

html = File.open(google_serp) { |file| file.read }
doc = Hpricot(html)

(doc/"a.l").each { |a| puts a.attributes['href'] }