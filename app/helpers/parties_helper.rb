module PartiesHelper
  def party_link(party)
    return if party.nil? or party.profiles.to_a.empty?
    link_to party, class: "party-link" do
      party.profiles.collect {|profile| avatar(profile)}.join(' ').html_safe
    end
  end
end
