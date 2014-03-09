class Profile
  include Mongoid::Document
  field :steam_profile_id, type: Integer
  field :name, type: String
  field :real_name, type: String
  field :steam_clan_id, type: Integer
  field :country_code, type: String
  field :state_code, type: String
  field :access_state, type: String
  field :configured, type: Boolean
  field :last_login, type: Time
  field :profile_url, type: String
  field :small_avatar_url, type: String
  field :big_avatar_url, type: String
  field :commentable, type: Boolean

  # game user is currently playing
  field :game_id, type: Integer
  field :game_title, type: String
  field :game_server_ip, type: String

  field :last_match, type: Date
  field :match_count, type: Integer
  field :war, type: Integer
  field :wins, type: Integer
  field :losses, type: Integer

  has_many :players

  def to_param
    steam_profile_id.to_s
  end

  def self.find_or_new_from_steam_profile_id(steam_profile_id)
    self.find_by(steam_profile_id: steam_profile_id) || self.new(self.profile_attributes_from_steam_profile( Dota.profiles(steam_profile_id)[0] ))
  end

  def self.find_or_create_by_steam_profile_id(steam_profile_id)
    self.find_by(steam_profile_id: steam_profile_id) || self.create(self.profile_attributes_from_steam_profile( Dota.profiles(steam_profile_id)[0] ))
  end

  def self.profile_attributes_from_steam_profile(steam_profile)
    {
      steam_profile_id: steam_profile.id,
      name: steam_profile.person_name,
      real_name: steam_profile.real_name,
      steam_clan_id: steam_profile.clan_id,
      country_code: steam_profile.country_code,
      state_code: steam_profile.state_code,
      access_state: steam_profile.access_state,
      configured: steam_profile.configured?,
      last_login: steam_profile.last_login,
      profile_url: steam_profile.profile_url,
      small_avatar_url: steam_profile.small_avatar_url,
      big_avatar_url: steam_profile.big_avatar_url,
      commentable: steam_profile.commentable?
    }
  end


end
