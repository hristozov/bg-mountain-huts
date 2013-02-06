class User
  include Mongoid::Document
  field :email, type: String # TODO: validate!
  field :password, type: String
end