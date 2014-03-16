require 'test_helper'

class PartiesControllerTest < ActionController::TestCase
  setup do
    @Party = FactoryGirl.create :profile
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil @matches#assigns(:matches)
  end

  test "should show party" do
    get :show, id: @party
    assert_response :success
  end
end
