module Api::V1::Addresses
  class LocationTypesController < Api::V1::ApiController
    before_action :set_location_type, only: [:show, :update, :destroy]

    # GET /location_types
    def index
      @location_type = LocationType.all

      render json: @location_type
    end

    # GET /location_types/1
    def show
      render json: @location_type
    end

    def self.check_exists(location_type_id)
      return true if LocationType.exists?(location_type_id)

      render json: { error: 'LocationType does not exists',
                     value: { id: location_type_id } },
             status: :bad_request
      false
    end

    def check_exists!(location_type)
      return true unless LocationType.exists?(name: location_type)

      render json: { error: 'Already exists',
                     value: { name: location_type } },
             status: :conflict
      false
    end

    def create_new_location_type(location_type)
      @location_type = LocationType.new(name: location_type)
      return true if @location_type.save

      render json: { error: @location_type.errors },
             status: :unprocessable_entity
      false
    end

    def create_location_type(location_type)
      return false unless check_exists!(location_type)

      return false unless create_new_location_type(location_type)

      true
    end

    # POST /location_types
    def create
      unless params['name'].nil?
        return unless create_location_type(params)

        render json: @location_type, status: :created
        return
      end
      unless params['location_types'].nil?
        count = 0
        params['location_types'].each do |location_type|
          return unless create_location_type(location_type)

          count += 1
        end
        render json: { count: count }, status: :created
        return
      end
      render status: :no_content
    end

    # PATCH/PUT /location_types/1
    def update
      if @location_type.update(location_type_params)
        render json: @location_type
      else
        render json: @location_type.errors, status: :unprocessable_entity
      end
    end

    # DELETE /location_types/1
    def destroy
      @location_type.destroy
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_location_type
      @location_type = LocationType.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def location_type_params
      params.require(:location_type).permit(:name,
                                            :location_types => [])
    end
  end
end