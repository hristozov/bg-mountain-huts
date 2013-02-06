class Cookie
  include Mongoid::Document
  field :data, type: String
  field :date, type: Time
end