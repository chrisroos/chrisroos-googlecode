require File.join(File.dirname(__FILE__), '..', 'test_helper')

class PersonTest < Test::Unit::TestCase
  
  def setup
    @date = Date.parse('2009-01-01')
    @timestamp = Time.parse('2009-01-01')
  end
  
  def test_should_be_able_to_set_created_on
    person = Person.new(:created_on => @date)
    assert_equal @date, person.created_on, "FAIL: Couldn't mass assign the created_on attribute"
    person.save!
    assert_equal @date, person.created_on, "FAIL: Couldn't mass assign the created_on attribute"
  end
  
  def test_should_be_able_to_set_created_at
    person = Person.create!(:created_at => @timestamp)
    assert_equal @timestamp, person.created_at, "FAIL: Couldn't mass assign the created_at attribute"
  end
  
  def test_should_be_able_to_set_updated_on
    person = Person.new(:updated_on => @date, :created_at => @timestamp, :created_on => @date, :updated_at => @timestamp)
    assert_equal @date, person.updated_on, "FAIL: Couldn't mass assign the updated_on attribute"
    person.save!
    assert_equal @date, person.updated_on, "FAIL: Couldn't mass assign the updated_on attribute"
  end
  
  def test_should_be_able_to_set_updated_at
    person = Person.create!(:updated_at => @timestamp)
    assert_equal @timestamp, person.updated_at, "FAIL: Couldn't mass assign the updated_at attribute"
  end
  
end