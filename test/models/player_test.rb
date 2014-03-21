require 'test_helper'

class PlayerTest < ActiveSupport::TestCase
  setup do
    @match = FactoryGirl.create(:match)
    @player = @match.players.first
  end

  test "team should return team name" do
    assert_equal @player.team, "Radiant"
  end
  # test "the truth" do
  #   assert true
  # end
end
