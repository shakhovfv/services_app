class Locality < ApplicationRecord
  has_one :Locality
  has_one :LocalityType
  has_one :District
end
