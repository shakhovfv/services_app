class JurisdictionSerializer < ActiveModel::Serializer
  attributes :id, :sector, :address, :phone, :reception_of_citizens, :work_time,
             :email, :judge_fio, :district_id, :site, :index
end
