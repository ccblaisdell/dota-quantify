require 'test_helper'

class PartiesControllerTest < ActionController::TestCase
  setup do
    @party = FactoryGirl.create(:party)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil @parties
  end

  test "should show party" do
    get :show, id: @party
    assert_response :success
    assert_not_nil @matches
  end
end
