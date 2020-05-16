module Api::V1::Addresses
  class LocalityTypesController < Api::V1::ApiController
    before_action :set_locality_type, only: [:show, :update, :destroy]

    # GET /locality_types
    def index
      @locality_types = LocalityType.all

      render json: @locality_types
    end

    # GET /locality_types/1
    def show
      render json: @locality_type
    end

    def self.check_exists(locality_type_id)
      return true if LocalityType.exists?(locality_type_id)

      render json: { error: 'LocalityType does not exists',
                     value: { id: locality_type_id } },
             status: :bad_request
      false
    end

    def check_exists!(locality_type)
      return true unless LocalityType.exists?(name: locality_type)

      render json: { error: 'Already exists',
                     value: { name: locality_type } },
             status: :conflict
      false
    end

    def create_new_locality_type(locality_type)
      @locality_type = LocalityType.new(name: locality_type)
      return true if @locality_type.save

      render json: { error: @locality_type.errors },
             status: :unprocessable_entity
      false
    end

    def create_locality_type(locality_type)
      return false unless check_exists!(locality_type)

      return false unless create_new_locality_type(locality_type)

      true
    end

    # POST /locality_types
    def create
      unless params['name'].nil?
        return unless create_locality_type(params['name'])

        render json: @locality_type, status: :created
        return
      end
      unless params['locality_types'].nil?
        count = 0
        params['locality_types'].each do |locality_type|
          return unless create_locality_type(locality_type)

          count += 1
        end
        render json: { count: count }, status: :created
        return
      end
      render status: :no_content
    end

    # PATCH/PUT /locality_types/1
    def update
      if @locality_type.update(locality_type_params)
        render json: @locality_type
      else
        render json: @locality_type.errors, status: :unprocessable_entity
      end
    end

    # DELETE /locality_types/1
    def destroy
      @locality_type.destroy
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_locality_type
      @locality_type = LocalityType.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def locality_type_params
      params.require(:locality_type).permit(:name,
                                            :locality_types => [])
    end
  end
end
