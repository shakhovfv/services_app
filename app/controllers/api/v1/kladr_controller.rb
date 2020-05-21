module Api::V1
  class KladrController < ApiController
    require 'http'
    before_action :kladr_params, only: [:index]

    def index
      headers['Access-Control-Allow-Origin'] = '*'
      headers['Access-Control-Allow-Methods'] = 'POST, PUT, DELETE, GET, OPTIONS'
      headers['Access-Control-Request-Method'] = '*'
      headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization'

      address = "Санкт-Петербург, #{params[:str]}"
      request = "https://kladr-api.ru/api.php?query=#{address}&oneString=1&limit=50&withParent=0"
      reply = HTTP.get(request)

      results = JSON.parse(reply.body)
      puts "===> #{results}"

      addresses = [];
      locality_id = 0
      location_type_id = 0
      name = ""
      street = "";
      street_type = "";
      city = "";
      city_type = "";

      results['result'].each_with_index do |result, index|
        if result['contentType'] == 'street'
          name_parts = result['fullName'].split(', ')

          location_type_id = LocationType.find_by(name: name_parts[2].partition(' ').first.downcase).id
          street_type = name_parts[2].partition(' ').first
          name = name_parts[2].partition(' ').last.downcase
          street = name_parts[2].partition(' ').last
          
          locality_type_id = LocalityType.find_by(name: name_parts[1].partition(' ').first.downcase).id
          city_type = name_parts[1].partition(' ').first
          locality_id = Locality.find_by(name: name_parts[1].partition(' ').last.downcase, locality_type_id: locality_type_id).id
          city = name_parts[1].partition(' ').last;

          addresses << {
            id: index,
            title: city_type + ' ' + city + ', ' + street_type + ' ' + street,
            klard: {
              locality_id: locality_id,
              name: name,
              location_type_id: location_type_id,
              building: nil
            }
          }

          break
        end
      end

      addresses_with_buildings = [];
      results['result'].each_with_index do |result, index|
        if (result['contentType'] == 'building')
          addresses_with_buildings << {
            id: index,
            title: city_type + ' ' + city + ', ' + street_type + ' ' + street + ', ' + result['type'] + ' ' + result['name'],
            kladr: {
              locality_id: locality_id,
              name: name,
              location_type_id: location_type_id,
              building: result['name'].split(' ')[0].match(/(\d+)/)[0]
            }
          }
        end
      end

      if addresses_with_buildings.length > 0
        render :json => addresses_with_buildings.to_json
      else
        render :json => addresses.to_json
      end
    end

    private
    # Only allow a trusted parameter "white list" through.
    def kladr_params
      params.require(:str) #address from user
    end
  end
end