FactoryGirl.define do
  sequence :steam_account_id do |n|
    n + 1234567890
  end

  sequence :dota_account_id do |n|
    n + 123456
  end

  factory :profile do
    steam_account_id
    dota_account_id
    name              "noobKiller"
    small_avatar_url  "small_avatar.png"
    big_avatar_url    "big_avatar.png"
    follow            false

    factory :followed_profile do
      follow true
    end
  end

  factory :party do
    count         20
    wins          15
    strict_count  10
    strict_wins   5
    size          3
  end

  factory :player do
    dota_account_id       4294967295 # anonymous
    steam_account_id
    hero_id               26
    hero                  "Lion"
    kills                 10
    deaths                2
    assists               15
    kda                   [10,2,15]
    leaver_status         'stayed'
    gold                  3000
    last_hits             200
    denies                10
    gold_spent            20000
    hero_damage           15000
    tower_damage          500
    hero_healing          100
    level                 25
    xpm                   500
    gpm                   500
    items                 []
    additional_unit_items []
    additional_unit_names []
    upgrades              []

    # first 5 will be radiant, the rest will be dire
    sequence :slot do |n|
      n <= 5 ? n - 1 : n + 122
    end
  end

  factory :match do
    match_id                12345
    seq_num                 1
    start                   Time.now - 3.days
    lobby                   'ranked'
    mode                    'all pick'
    winner                  'radiant'
    duration                3600
    first_blood             60
    dire_tower_status       0
    radiant_tower_status    100
    dire_barracks_status    0
    radiant_barracks_status 100
    won true

    after(:build) do |match|
      # Embed players
      10.times do
        match.players.build(FactoryGirl.attributes_for(:player))
      end

      match.profiles = [
        FactoryGirl.create(:profile, steam_account_id: match.players.first.steam_account_id), 
        FactoryGirl.create(:followed_profile, steam_account_id: match.players[1].steam_account_id)
      ]

      # Reset the sequences
      FactoryGirl.reload
    end

  end
end