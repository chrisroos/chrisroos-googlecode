require File.dirname(__FILE__) + '/../test_helper'

class ResourceTest < Test::Unit::TestCase

  def test_should_only_create_one_tag
    tag = Tag.new(:name => 'TAG')
    resource_1 = Resource.create!
    resource_1.tag 'TAG'
    resource_2 = Resource.create!
    resource_2.tag 'TAG'
    
    assert_equal 2, Tag.find_by_name('TAG').resources.size
  end
  
end