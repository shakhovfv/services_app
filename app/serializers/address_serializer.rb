class AddressSerializer < ActiveModel::Serializer
  attributes :id, :name, :buildings, :locality_id, :location_type_id
end
