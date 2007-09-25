require File.dirname(__FILE__) + '/../test_helper'

class PaperTest < Test::Unit::TestCase
  
  def test_should_have_many_editions
    edition = Edition.new
    paper = Paper.new
    paper.editions << edition
    assert_equal [edition], paper.editions
  end

  def test_should_validate_presence_of_name
    paper = Paper.new(:title => nil)
    paper.valid?
    assert_equal "can't be blank", paper.errors[:title]
  end
  
end
