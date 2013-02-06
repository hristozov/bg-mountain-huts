class Nonce
  include Mongoid::Document
  field :token, type: String
  field :date, type: Time
end