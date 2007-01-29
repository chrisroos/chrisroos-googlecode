#!/usr/bin/env ruby

class Test
  def initialize
    @added, @removed = [], []
  end
  def add_responsibility(responsibility)
    @added << responsibility
  end
  def remove_responsibility(responsibility)
    @removed << responsibility
  end
  def added_responsibilities
    (@added - @removed).sort
  end
  def removed_responsibilities
    (@removed - @added).sort
  end
  def added_responsibilities?
    !added_responsibilities.empty?
  end
  def removed_responsibilities?
    !removed_responsibilities.empty?
  end
  def changed_responsibilities?
    added_responsibilities? || removed_responsibilities?
  end
end

tests = {}
class_under_test = ''

while line = gets
  if line =~ /Index: (.*)/
    if (test_name = File.basename($1, '.rb')) =~ /_test$/
      name_of_class_under_test = test_name.sub(/_test/, '')
      class_under_test = name_of_class_under_test.capitalize.gsub(/_(\w)/) { |m| $1.capitalize }
      tests[class_under_test] = Test.new
    end
  else
    if line =~ /-\s*def test_(.*)/
      responsibility = $1.gsub(/_/, ' ')
      tests[class_under_test].remove_responsibility(responsibility)
    elsif line =~ /\+\s*def test_(.*)/
      responsibility = $1.gsub(/_/, ' ')
      tests[class_under_test].add_responsibility(responsibility)
    end
  end
end

tests.sort.each do |test_name, test|
  if test.changed_responsibilities?
    puts '--- ' + test_name
    test.added_responsibilities.each { |responsibility| puts '+ ' + responsibility } if test.added_responsibilities?
    test.removed_responsibilities.each { |responsibility| puts '- ' + responsibility } if test.removed_responsibilities?
    puts ''
  end
end