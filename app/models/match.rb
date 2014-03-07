class Match
  include Mongoid::Document
  field :type, type: String
  field :mode, type: String
  field :date, type: Date
  field :region, type: String
  field :duration, type: Integer
  field :winner, type: String
end
