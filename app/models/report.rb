class Report
  include Mongoid::Document
  include Mongoid::Timestamps

  field :date, type: Time

  has_many :matches

end
