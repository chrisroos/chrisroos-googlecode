require File.dirname(__FILE__) + '/../test_helper'

class TagTest < Test::Unit::TestCase
  
  def test_should_validate_uniqueness_of_name
    Tag.create!(:name => 'TAG')
    exception = assert_raise(ActiveRecord::RecordInvalid) { Tag.create!(:name => 'TAG') }
    assert_equal 'Validation failed: Name has already been taken', exception.message
  end
  
end