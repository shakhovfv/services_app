class LocalitySerializer < ActiveModel::Serializer
  attributes :id, :name, :locality_type_id, :locality_id, :district_id
end
