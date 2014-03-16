FactoryGirl.define do
  factory :profile do
    # steam_account_id  1234567890
    dota_account_id   123456
    # name              "noobKiller"
    # small_avatar_url  "small_avatar.png"
    # big_avatar_url    "big_avatar.png"
    # follow            true
  end

  factory :party do
    count         20
    # wins          15
    # strict_count  10
    # strict_wins   5
    # size          3
  end

  factory :player do
    dota_account_id       123456
    steam_account_id      1234567890
    # slot                  0
    # hero                  "Lion"
    # kills                 10
    # deaths                2
    # assists               15
    # kda                   [10,2,15]
    # leaver_status         'stayed'
    # gold                  3000
    # last_hits             200
    # denies                10
    # gold_spent            20000
    # hero_damage           15000
    # tower_damage          500
    # hero_healing          100
    # level                 25
    # xpm                   500
    # gpm                   500
    # items                 []
    # additional_unit_items []
    # additional_unit_names []
    # upgrades              []
    # won                   true
  end

  factory :match do
    match_id                12345
    # seq_num                 1
    # start                   Time.now - 3.days
    # lobby                   'ranked'
    # mode                    'all pick'
    # winner                  'radiant'
    # duration                3600
    # first_blood             60
    # dire_tower_status       0
    # radiant_tower_status    100
    # dire_barracks_status    0
    # radiant_barracks_status 100
  end
end