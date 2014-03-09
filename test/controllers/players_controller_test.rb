require 'test_helper'

class PlayersControllerTest < ActionController::TestCase
  setup do
    @player = players(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:players)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create player" do
    assert_difference('Player.count') do
      post :create, player: { addition_unit_items: @player.addition_unit_items, additional_unit_names: @player.additional_unit_names, assists: @player.assists, deaths: @player.deaths, denies: @player.denies, gold: @player.gold, gold_spent: @player.gold_spent, gpm: @player.gpm, hero: @player.hero, hero_damage: @player.hero_damage, hero_healing: @player.hero_healing, hero_id: @player.hero_id, items: @player.items, kda: @player.kda, kills: @player.kills, last_hits: @player.last_hits, leaver_status: @player.leaver_status, level: @player.level, slot: @player.slot, steam_profile_id: @player.steam_profile_id, tower_damage: @player.tower_damage, upgrades: @player.upgrades, xpm: @player.xpm }
    end

    assert_redirected_to player_path(assigns(:player))
  end

  test "should show player" do
    get :show, id: @player
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @player
    assert_response :success
  end

  test "should update player" do
    patch :update, id: @player, player: { addition_unit_items: @player.addition_unit_items, additional_unit_names: @player.additional_unit_names, assists: @player.assists, deaths: @player.deaths, denies: @player.denies, gold: @player.gold, gold_spent: @player.gold_spent, gpm: @player.gpm, hero: @player.hero, hero_damage: @player.hero_damage, hero_healing: @player.hero_healing, hero_id: @player.hero_id, items: @player.items, kda: @player.kda, kills: @player.kills, last_hits: @player.last_hits, leaver_status: @player.leaver_status, level: @player.level, slot: @player.slot, steam_profile_id: @player.steam_profile_id, tower_damage: @player.tower_damage, upgrades: @player.upgrades, xpm: @player.xpm }
    assert_redirected_to player_path(assigns(:player))
  end

  test "should destroy player" do
    assert_difference('Player.count', -1) do
      delete :destroy, id: @player
    end

    assert_redirected_to players_path
  end
end
