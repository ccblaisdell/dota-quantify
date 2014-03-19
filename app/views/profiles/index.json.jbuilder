json.array!(@profiles) do |profile|
  json.extract! profile, :id, :steam_account_id, :dota_account_id, :name, :profile_url, :small_avatar_url, :big_avatar_url, :follow
  json.url profile_url(profile, format: :json)
end
