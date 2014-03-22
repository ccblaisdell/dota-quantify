FactoryGirl.define do
  sequence :steam_account_id do |n|
    # This is the magic number in Player#convert_32_bit_account_id_to_64_bit_steam_id
    n + 76561197960265728
  end

  sequence :dota_account_id do |n|
    n
  end

  factory :profile do
    steam_account_id
    dota_account_id
    small_avatar_url  "small_avatar.png"
    big_avatar_url    "big_avatar.png"
    follow            false

    sequence(:name) {|n| "noobKiller_#{n}"}

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

    factory :named_player do
      dota_account_id
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
      2.times { match.players.build(FactoryGirl.attributes_for(:named_player)) }
      8.times { match.players.build(FactoryGirl.attributes_for(:player)) }

      # Associate profiles with the named players
      for player in match.players.named
        match.profiles << FactoryGirl.create(:profile,
          dota_account_id:  player.dota_account_id,
          steam_account_id: player.steam_account_id,
          # TODO: have some followed, some not followed profiles
          follow: true 
        )
      end

      # Reset the sequences
      FactoryGirl.reload
    end

  end
end