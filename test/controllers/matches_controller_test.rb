require 'test_helper'

class MatchesControllerTest < ActionController::TestCase
  setup do
    @match = FactoryGirl.create :match
  end

  test "should asyncrhonously fetch a match" do
    get :fetch
    assert_redirected_to matches_path
  end

  test "should asyncrhonously fetch a bunch of matches" do
    get :fetch_for_followed
    assert_redirected_to matches_path
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:matches)
  end

  test "should show match" do
    get :show, id: @match
    assert_response :success
  end
end
