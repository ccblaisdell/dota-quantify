module ProfilesHelper
  def avatar(profile, size=:small)
    return nil if profile.nil?
    image_tag profile.send("#{size.to_s}_avatar_url".to_sym), class: "avatar"
  end

  def profile_link(profile)
    return content_tag :span, '---', class: "profile-anonymous" if profile.nil?
    link_to profile.name, profile, class: "profile-link"
  end

  def profile_menu(profile, *links)
    menu link_to('Overview', profile), 
      link_to('Matches', matches_profile_path(profile)), 
      link_to('Heroes', heroes_profile_path(profile)), 
      links
  end
end
