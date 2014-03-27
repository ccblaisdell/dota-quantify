module PartiesHelper
  def party_link(party)
    link_to party, class: "party-link" do
      party.profiles.collect {|profile| avatar(profile)}.join(' ').html_safe
    end
  end
end
