require File.dirname(__FILE__) + '/../lib/mock_request'
require 'test/unit'

class MockRequestTest < Test::Unit::TestCase
  
  def test_should_store_path
    path = 'path'
    mock_request = MockRequest.new(path)
    assert_equal path, mock_request.path
  end
  
  def test_should_default_path_parameters_to_nil
    mock_request = MockRequest.new('')
    assert_equal nil, mock_request.path_parameters
  end
  
  def test_should_allow_path_parameters_to_be_updated
    mock_request = MockRequest.new('')
    mock_request.path_parameters = path_parameters = 'path_parameters'
    assert_equal path_parameters, mock_request.path_parameters
  end
  
end