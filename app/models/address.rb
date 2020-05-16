class Address < ApplicationRecord
  has_one :Locality
  has_one :LocationType
end
