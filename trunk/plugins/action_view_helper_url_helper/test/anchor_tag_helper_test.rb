require File.dirname(__FILE__) + '/../lib/anchor_tag_helper'
require 'test/unit'

class AnchorTagHelperTest < Test::Unit::TestCase
  
  def test_should_give_an_empty_string_if_we_cannot_find_a_url
    assert_equal '', AnchorTagHelper.new('').url
  end
  
  def test_should_extract_url_from_anchor_tag
    assert_equal 'abc.com', AnchorTagHelper.new('<a href="abc.com">test</a>').url
  end
  
  def test_should_extract_url_from_anchor_tag_containing_css_class
    assert_equal 'abc.com', AnchorTagHelper.new('<a href="abc.com" class="foo">test</a>').url
  end
  
  def test_should_extract_url_from_anchor_tag_when_href_is_surrounded_by_single_quotes
    assert_equal 'abc.com', AnchorTagHelper.new("<a href='abc.com'>test</a>").url
  end
  
  def test_should_provide_url_with_parameters_removed
    assert_equal 'abc.com', AnchorTagHelper.new("<a href='abc.com'>test</a>").url_without_parameters
  end
  
  def test_should_provide_url_with_any_parameters_removed
    assert_equal 'abc.com', AnchorTagHelper.new("<a href='abc.com?param=true'>test</a>").url_without_parameters
  end
  
  def test_should_add_css_class_to_anchor
    anchor_tag_helper = AnchorTagHelper.new('<a href="abc.com">abc</a>')
    assert anchor_tag_helper.anchor_with_css_class('css_class') =~ / class="css_class" /
  end
  
  def test_should_not_change_quotes_in_original_anchor
    anchor_tag = "<a href='abc.com'>abc</a>"
    anchor_tag_helper = AnchorTagHelper.new(anchor_tag)
    assert_equal "<a href='abc.com'>abc</a>", anchor_tag_helper.anchor_tag
  end
  
  def test_should_not_change_quotes_in_original_anchor_having_added_css_class
    anchor_tag = "<a href='abc.com'>abc</a>"
    anchor_tag_helper = AnchorTagHelper.new(anchor_tag)
    assert_equal "<a class=\"wem\" href='abc.com'>abc</a>", anchor_tag_helper.anchor_with_css_class('wem')
  end
  
end