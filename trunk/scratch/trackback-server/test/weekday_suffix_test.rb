require File.join(File.dirname(__FILE__), 'test_helper')
require 'weekday_suffix'

class WeekdaySuffixTest < Test::Unit::TestCase
  
  DaysWithStSuffix = [1, 21, 31]
  DaysWithNdSuffix = [2, 22]
  DaysWithRdSuffix = [3, 23]
  DaysWithThSuffix = (1..31).to_a - DaysWithStSuffix - DaysWithNdSuffix - DaysWithRdSuffix
  
  def test_should_be_st
    DaysWithStSuffix.each do |day|
      assert_equal 'st', WeekdaySuffix.new(day).suffix
    end
  end
  
  def test_should_be_nd
    DaysWithNdSuffix.each do |day|
      assert_equal 'nd', WeekdaySuffix.new(day).suffix
    end
  end
  
  def test_should_be_rd
    DaysWithRdSuffix.each do |day|
      assert_equal 'rd', WeekdaySuffix.new(day).suffix
    end
  end
  
  def test_should_be_th
    DaysWithThSuffix.each do |day|
      assert_equal 'th', WeekdaySuffix.new(day).suffix
    end
  end
  
end