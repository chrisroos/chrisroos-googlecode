require File.dirname(__FILE__) + '/test_helper'
require 'routing_redirection'

class RedirectionController; end
class DefaultController; end

class RoutingRedirectionTest < Test::Unit::TestCase
  
  def setup
    @routeset = ActionController::Routing::RouteSet.new
    @routeset.draw do |rs|
      rs.connect '', :controller => 'default'
      rs.permanently_redirect 'foo/bar/:id', :controller => 'default', :action => 'index'
    end
  end
  
  def test_should_default_to_redirection_controller_if_request_uri_contains_trailing_slash
    request = ActionController::TestRequest.new
    request.request_uri = '/foo/'
    assert_equal RedirectionController, @routeset.recognize(request)
  end
  
  def test_should_default_to_permanent_redirect_action_if_request_uri_contains_trailing_slash
    request = ActionController::TestRequest.new
    request.request_uri = '/foo/'
    @routeset.recognize(request)
    expected_path_parameters = {:action => 'permanently_redirect_urls_with_trailing_slash'}
    assert_equal expected_path_parameters, request.path_parameters
  end
  
  def test_should_not_default_to_redirection_controller_if_request_uri_contains_only_a_trailing_slash
    request = ActionController::TestRequest.new
    request.request_uri = '/'
    assert_not_equal RedirectionController, @routeset.recognize(request)
  end
  
  def test_should
    request = ActionController::TestRequest.new
    request.request_uri = '/foo/bar/999'
    @routeset.recognize(request)
    expected_path_parameters = {'controller' => 'redirection', 'action' => 'permanently_redirect', 'id' => '999', 'destination_params' => {'controller' => 'default', 'action' => 'index'}}
    assert_equal expected_path_parameters, request.path_parameters
  end
  
end