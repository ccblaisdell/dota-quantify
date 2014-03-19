module ProfilesHelper
  def avatar(profile, size=:small)
    return nil if profile.nil?
    image_tag profile.send("#{size.to_s}_avatar_url".to_sym), class: "avatar"
  end

  def profile_link(profile)
    return content_tag :span, 'Anonymous', class: "profile-anonymous" if profile.nil?
    link_to profile.name, profile, class: "profile-link"
  end
end
