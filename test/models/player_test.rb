require 'test_helper'

class PlayerTest < ActiveSupport::TestCase
  setup do
    @match = FactoryGirl.create(:match)
    @player = @match.players.first
  end

  test "won? should report if we won" do
    assert @player.won?
  end

  test "name should return name for known user" do
    assert_not_equal @player.name, "anonymous"
  end

  test "name should return anonymous for anonymous user" do
    assert_equal @match.players.last.name, "anonymous"
  end

  test "anonymous player is anonymous" do
    assert @match.players.last.anonymous?
  end

  test "team should return team name" do
    assert_equal @player.team, "Radiant"
  end
  # test "the truth" do
  #   assert true
  # end
end
