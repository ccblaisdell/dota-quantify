require 'test_helper'

class PartiesControllerTest < ActionController::TestCase
  setup do
    @party = FactoryGirl.create(:party)
    @match = FactoryGirl.create(:match)
    @party.matches << @match
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:parties)
  end

  test "should show party" do
    get :show, id: @party
    assert_response :success
    assert_not_nil assigns(:matches)
  end
end
