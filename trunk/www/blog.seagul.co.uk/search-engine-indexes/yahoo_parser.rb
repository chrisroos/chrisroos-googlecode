#! /usr/bin/env ruby

while line = gets
  url = line[/(http:\/\/.*?)\t/, 1]
  puts url if url
end