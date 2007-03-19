require File.dirname(__FILE__) + '/test_helper'

class ApplicationController < ActionController::Base; end

require 'redirection_controller'
class RedirectionController; def rescue_action(e) raise e end; end

class RedirectionControllerTest < Test::Unit::TestCase
  
  ActionController::Routing::Routes.draw do |map|
    map.connect ':controller/:action/:id'
  end
  
  def setup
    @controller = RedirectionController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end
  
  def test_should_permanently_redirect_urls_with_trailing_slash
    get :permanently_redirect_urls_with_trailing_slash
    assert_response 301
  end
  
  def test_should_redirect_to_request_uri_without_the_trailing_slash
    @request.set_REQUEST_URI('/foo/')
    get :permanently_redirect_urls_with_trailing_slash
    assert_equal 'http://test.host/foo', @response.headers['Location']
  end
  
  def test_should_redirect_to_request_uri_without_the_trailing_slash_but_with_the_querystring
    @request.set_REQUEST_URI('/foo/?id=123&bar=baz')
    get :permanently_redirect_urls_with_trailing_slash
    assert_equal 'http://test.host/foo?id=123&bar=baz', @response.headers['Location']
  end
  
  def test_should_respond_with_400_if_we_dont_supply_any_destination_params
    get :permanently_redirect
    assert_response 400
  end
  
  def test_should_respond_with_400_if_we_dont_supply_a_controller_in_the_destination_params
    get :permanently_redirect, :destination_params => {:not_controller => 'destination_controller'}
    assert_response 400
  end
  
  def test_should_permanently_redirect_with_301_status
    get :permanently_redirect, :destination_params => {:controller => 'destination_controller'}
    assert_response 301
  end
  
  def test_should_redirect_to_params_merged_with_destination_params
    get :permanently_redirect, :id => 999, :destination_params => {:controller => 'destination_controller', :action => 'destination_action'}
    assert_redirected_to :controller => 'destination_controller', :action => 'destination_action', :id => 999
  end
  
end