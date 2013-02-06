class MapObject
  include Mongoid::Document
  field :name, type: String
  field :lat, type: Float
  field :lng, type: Float
  field :alt, type: Float
  field :description, type: String
end
