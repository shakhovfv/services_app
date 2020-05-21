module Api::V1::Jurisdictions
  class JurisdictionsController < Api::V1::ApiController

    before_action :set_jurisdiction, only: [:show, :update, :destroy]

    # GET /jurisdictions
    def index
      @jurisdictions = Jurisdiction.all

      render json: @jurisdictions
    end

    # GET /jurisdictions/1
    def show
      render json: @jurisdiction
    end

    def self.check_exists(jurisdiction_id)
      return true if Jurisdiction.exists?(jurisdiction_id)

      render json: { error: 'Jurisdiction does not exists',
                     value: { jurisdiction_id: jurisdiction_id } },
             status: :bad_request
      false
    end

    def check_exists!(args)
      return true unless Jurisdiction.exists?(
        sector: args['sector'],
        district_id: args['district_id']
      )

      render json: { error: 'Already exists',
                     value: { sector: args['sector'],
                              district: args['district_id'] } },
             status: :conflict
      false
    end

    # POST /jurisdictions
    def create
      #return unless check_exists!(jurisdiction_params)

      if Jurisdiction.exists?(sector: jurisdiction_params['sector'])
        render json: @jurisdiction, status: :ok && return
      end

      @jurisdiction = Jurisdiction.new(jurisdiction_params)

      if @jurisdiction.save
        render json: @jurisdiction, status: :created
      else
        render json: @jurisdiction.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /jurisdictions/1
    def update
      if @jurisdiction.update(jurisdiction_params)
        render json: @jurisdiction
      else
        render json: @jurisdiction.errors, status: :unprocessable_entity
      end
    end

    # DELETE /jurisdictions/1
    def destroy
      @jurisdiction.destroy
    end

    private

    def valid_json?(json)
      JSON.parse(json)
      return true
    rescue JSON::ParserError => e
      return false
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_jurisdiction
      if valid_json? (params[:id])
        data = JSON.parse(params[:id])
        @address = Address.find_by(name: data['name'], location_type_id: data['location_type_id'].to_i, locality_id: data['locality_id'].to_i)

        @address.buildings.each do |part|
          if part['numbers'].include? data['building']
            @jurisdiction = Jurisdiction.find(part['jurisdiction_id'])
            break
          end
        end
        
      else
        @jurisdiction = Jurisdiction.find(params[:id])
      end
    end

    # Only allow a trusted parameter "white list" through.
    def jurisdiction_params
      params.require(:jurisdiction).permit(
        :sector,
        :address,
        :phone,
        :reception_of_citizens,
        :work_time,
        :email,
        :judge_fio,
        :district_id,
        :site,
        :index
      )
    end
  end
end