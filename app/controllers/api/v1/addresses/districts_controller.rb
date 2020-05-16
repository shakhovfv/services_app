module Api::V1::Addresses
  class DistrictsController < Api::V1::ApiController

  before_action :set_district, only: [:show, :update, :destroy]

  # GET /districts
  def index
    @districts = District.all

    render json: @districts
  end

  # GET /districts/1
  def show
    render json: @district
  end

  def self.check_exists(district_id)
    return true if District.exists?(district_id)

    render json: { error: 'District does not exists',
                   value: { district_id: district_id } },
           status: :bad_request
    false
  end

  def check_exists!(args)
    return true unless District.exists?(
      name: args['name'],
      locality_id: args['locality_id']
    )

    render json: { error: 'Already exists',
                   value: { name: args['name'],
                            locality_id: args['locality_id'] } },
           status: :conflict
    false
  end

  def create_new_district(args)
    @district = District.new(name: args['name'],
                             locality_id: args['locality_id'])
    return true if @district.save

    render json: { error: @district.errors },
           status: :unprocessable_entity
    false
  end

  def create_district(args)
    return false unless LocalitiesController.check_exists(args['locality_id'])

    return false unless check_exists!(args)

    return false unless create_new_district(args)

    true
  end

  # POST /districts
  def create
    unless params['name'].nil?
      return unless create_district(params)

      render json: @district, status: :created
      return
    end
    unless params['districts'].nil?
      count = 0
      params['districts'].each do |district|
        return unless create_district(district)

        count += 1
      end
      render json: { count: count }, status: :created
      return
    end
    render status: :no_content
  end

  # PATCH/PUT /districts/1
  def update
    if @district.update(district_params)
      render json: @district
    else
      render json: @district.errors, status: :unprocessable_entity
    end
  end

  # DELETE /districts/1
  def destroy
    @district.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_district
    @district = District.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def district_params
    params.require(:district).permit(:name,
                                     :locality_id,
                                     :districts => [])
  end

  end
end
