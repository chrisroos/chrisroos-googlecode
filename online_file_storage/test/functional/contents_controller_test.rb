require File.dirname(__FILE__) + '/../test_helper'
require 'contents_controller'

# Re-raise errors caught by the controller.
class ContentsController; def rescue_action(e) raise e end; end

class ContentsControllerTest < Test::Unit::TestCase
  fixtures :contents

  def setup
    @controller = ContentsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:contents)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end
  
  def test_should_create_content
    old_count = Content.count
    post :create, :content => { }
    assert_equal old_count+1, Content.count
    
    assert_redirected_to content_path(assigns(:content))
  end

  def test_should_show_content
    get :show, :id => 1
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => 1
    assert_response :success
  end
  
  def test_should_update_content
    put :update, :id => 1, :content => { }
    assert_redirected_to content_path(assigns(:content))
  end
  
  def test_should_destroy_content
    old_count = Content.count
    delete :destroy, :id => 1
    assert_equal old_count-1, Content.count
    
    assert_redirected_to contents_path
  end
end
