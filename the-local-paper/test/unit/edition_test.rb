require File.dirname(__FILE__) + '/../test_helper'

class EditionsTest < Test::Unit::TestCase

  def test_should_belong_to_paper
    paper = Paper.new
    edition = Edition.new(:paper => paper)
    assert_equal paper, edition.paper
  end
  
  def test_should_have_many_articles
    article = Article.new
    edition = Edition.new
    edition.articles << article
    assert_equal [article], edition.articles
  end
  
  def test_should_validate_presence_of_published_on
    edition = Edition.new(:published_on => nil)
    edition.valid?
    assert_equal "can't be blank", edition.errors[:published_on]
  end
  
  def test_should_validate_presence_of_label
    edition = Edition.new(:label => nil)
    edition.valid?
    assert_equal "can't be blank", edition.errors[:label]
  end
  
  def test_should_validate_presence_of_paper
    edition = Edition.new(:paper => nil)
    edition.valid?
    assert_equal "can't be blank", edition.errors[:paper]
  end
  
  def test_should_validate_associated_paper
    paper = Paper.new
    paper.stubs(:valid).returns(false)
    edition = Edition.new(:paper => paper)
    edition.valid?
    assert_equal "is invalid", edition.errors[:paper]
  end
  
end
