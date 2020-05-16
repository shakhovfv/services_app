module Api::V1::Addresses
  class AddressesController < Api::V1::ApiController

    before_action :set_address, only: [:show, :update, :destroy]
    before_action :set_location_type, only: :create

    # GET /addresses
    def index
      @addresses = Address.all

      render json: @addresses
    end

    # GET /addresses/1
    def show
      render json: @address
    end

    def check_exists!(args)
      if args['location_type_id'].to_i.zero?
        args['location_type_id'] = nil
      end
      return true unless Address.exists?(
        name: args['name'], location_type_id: args['location_type_id'],
        locality_id: args['locality_id']
      )

      render json: { error: 'Already exists',
                     value: { name: args['name'],
                              location_type_id: args['location_type_id'],
                              locality_id: args['locality_id'] } },
             status: :conflict
      false
    end

    def check_buildings(buildings)
      buildings.each do |part|
        unless part['district_id'].nil?
          return false unless DistrictsController.check_exists(part['district_id'])
        end
        unless part['jurisdiction_id'].nil?
          return false unless Api::V1::Jurisdictions::JurisdictionsController.check_exists(
            part['jurisdiction_id']
          )
        end
      end
      true
    end

    # POST /addresses
    def create
      return unless LocalitiesController.check_exists(
        address_params['locality_id']
      )

      return unless LocationTypesController.check_exists(
        address_params['location_type_id']
      )

      return unless check_exists!(address_params)

      return unless check_buildings(address_params['buildings'])

      @address = Address.new(address_params)
      if @address.save
        render json: @address, status: :created
      else
        render json: @address.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /addresses/1
    def update
      if @address.update(address_params)
        render json: @address
      else
        render json: @address.errors, status: :unprocessable_entity
      end
    end

    # DELETE /addresses/1
    def destroy
      @address.destroy
    end

    private

    def set_location_type
      return if address_params['location_type_id'].to_i.positive?

      address_params['location_type_id'] = nil
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_address
      @address = Address.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def address_params
      params.require(:address).permit(:name,
                                      :location_type_id,
                                      :locality_id,
                                      buildings: [:district_id,
                                                  :jurisdiction_id,
                                                  :numbers => []])
    end
  end
end