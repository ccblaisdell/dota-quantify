require 'test_helper'

class ProfilesControllerTest < ActionController::TestCase
  setup do
    @profile = FactoryGirl.create(:profile)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:profiles)
  end

  test "should get all" do
    get :all
    assert_response :success
    assert_not_nil assigns(:profiles)
  end

  test "should get show" do
    get :show, id: @profile
    assert_response :success
  end
end
