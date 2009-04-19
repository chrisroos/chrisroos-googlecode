require File.join(File.dirname(__FILE__), '..', 'test_helper')

class PersonTest < Test::Unit::TestCase
  
  def setup
    @date = Date.parse('2009-01-01')
    @timestamp = Time.parse('2009-01-01')
  end
  
  def test_should_be_able_to_set_created_on
    person = Person.new(:created_on => @date)
    assert_equal @date, person.created_on, assignment_failure_message(:created_on)
    person.save!
    assert_equal @date, person.created_on, persistance_failure_message(:created_on)
  end
  
  def test_should_be_able_to_set_created_at
    person = Person.new(:created_at => @timestamp)
    assert_equal @timestamp, person.created_at, assignment_failure_message(:created_at)
    person.save!
    assert_equal @timestamp, person.created_at, persistance_failure_message(:created_at)
  end
  
  def test_should_be_able_to_set_updated_on
    person = Person.new(:updated_on => @date)
    assert_equal @date, person.updated_on, assignment_failure_message(:updated_on)
    person.save!
    assert_equal @date, person.updated_on, persistance_failure_message(:updated_on)
  end
  
  def test_should_be_able_to_set_updated_at
    person = Person.new(:updated_at => @timestamp)
    assert_equal @timestamp, person.updated_at, assignment_failure_message(:updated_at)
    person.save!
    assert_equal @timestamp, person.updated_at, persistance_failure_message(:updated_at)
  end
  
  private
  
    def assignment_failure_message(column)
      "FAIL: Couldn't mass assign the #{column} attribute"
    end
    
    def persistance_failure_message(column)
      "FAIL: Couldn't persist the mass assigned #{column} attribute"
    end
  
end