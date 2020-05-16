module Api::V1::Addresses
  class LocalitiesController < Api::V1::ApiController
    before_action :set_locality, only: [:show, :update, :destroy]

    # GET /localities
    def index
      @localities = Locality.all

      render json: @localities
    end

    # GET /localities/1
    def show
      render json: @locality
    end

    def self.check_exists(locality_id)
      return true if Locality.exists?(locality_id)

      render json: { error: 'Locality does not exists',
                     value: { id: locality_id } },
             status: :bad_request
      false
    end

    def check_exists!(args)
      return true unless Locality.exists?(
        name: args['name'],
        locality_type_id: args['locality_type_id'],
        locality_id: args['locality_id']
      )

      render json: { error: 'Already exists',
                     value: { name: args['name'],
                              locality_id: args['locality_id'] } },
             status: :conflict
      false
    end

    def check_parent_exists(parent_id)
      return true if parent_id.nil?

      return true if Locality.exists?(parent_id)

      render json: { error: 'Parent id does not exists',
                     value: { locality_id: params['locality_id'] } },
             status: :bad_request
      false
    end

    def check_district_exists(district_id)
      return true if district_id.nil?

      return true if DistrictsController.check_exists(district_id)

      render json: { error: 'District id does not exists',
                     value: { district_id: params['district_id'] } },
             status: :bad_request
      false
    end

    def create_new_locality(args)
      @locality = Locality.new(name: args['name'],
                               locality_type_id: args['locality_type_id'],
                               locality_id: args['locality_id'],
                               district_id: args['district_id'])
      return true if @locality.save

      render json: { error: @locality.errors },
             status: :unprocessable_entity
      false
    end

    def create_locality(args)
      return false unless LocalityTypesController.check_exists(args['locality_type_id'])

      return false unless check_district_exists(args['district_id'])

      return false unless check_exists!(args)

      return false unless check_parent_exists(args['locality_id'])

      return false unless create_new_locality(args)

      true
    end

    # POST /localities
    def create
      unless params['name'].nil?
        return unless create_locality(params)

        render json: @locality, status: :created
        return
      end
      unless params['localities'].nil?
        count = 0
        params['localities'].each do |locality|
          return unless create_locality(locality)

          count += 1
        end
        render json: { count: count }, status: :created
        return
      end
      render status: :no_content
    end

    # PATCH/PUT /localities/1
    def update
      if @locality.update(locality_params)
        render json: @locality
      else
        render json: @locality.errors, status: :unprocessable_entity
      end
    end

    # DELETE /localities/1
    def destroy
      Locality.where(locality_id: @locality.id).delete_all
      @locality.delete
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_locality
      @locality = Locality.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def locality_params
      params.require(:locality).permit(:name,
                                       :locality_type_id,
                                       :locality_id,
                                       :district_id,
                                       :localities => [])
    end
  end
end
