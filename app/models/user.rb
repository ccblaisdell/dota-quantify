class User
  include Mongoid::Document
  field :name, type: String
  field :steam_id, type: String
  field :last_match, type: Date
  field :war, type: Integer
  field :match_count, type: Integer
  field :wins, type: Integer
  field :losses, type: Integer
end
