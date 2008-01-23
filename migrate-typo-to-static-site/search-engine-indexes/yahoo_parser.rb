#! /usr/bin/env ruby

while line = gets
  puts line[/(http:\/\/.*?)\t/, 1]
end