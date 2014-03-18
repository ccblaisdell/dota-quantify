module ProfilesHelper
  def avatar(profile, size=:small)
    image_tag profile.send("#{size.to_s}_avatar_url".to_sym), class: "avatar"
  end
end
