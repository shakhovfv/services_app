module Api::V1::Cases
  class CourtsController < Api::V1::ApiController
    before_action :set_court, only: [:show, :update, :destroy]

    # GET /courts
    def index
      if params[:sbj_id].to_i > 0
        @courts = Court.where(subject_id: params[:sbj_id])
      elsif params[:sbj_index].to_i > 0
        @courts = Court.where(subject_id: Subject.find_by_index(params[:sbj_index]).id)
      else
        @courts = Court.all
      end

      render json: @courts
    end

    # GET /courts/1
    def show
      render json: @court
    end

    # POST /courts/load
    # curl -H "Authorization: Token token=JsRIbhB8kcbw4MaIYrcjsAtt" -X GET http://localhost:3000/v1/courts/load
    def load
      if Subject.all.empty?
        render json: "No subjects", status: :bad_request
      end

      @count = 0
      Subject.all.each do |subject|
        url = "https://sudrf.ru/index.php?id=300&act=ajax_search&searchtype=sp&court_subj=#{subject.index}&suds_subj="
        unparsed_page = HTTParty.get(url, :verify => false)
        parsed_page = Nokogiri::HTML(unparsed_page)
        list = parsed_page.css('option')
        @count = list.count

        i = 1
        while i < @count
          if Court.find_by_index(list[i].values[0].to_i).nil?
            @court = Court.create(name: list[i].text, index: list[i].values[0], subject_id: subject.id)
          end
          i += 1
        end
      end

      render json: @count, status: :created, location: @court
    end

    # POST /courts
    def create
      @court = Court.new(court_params)

      if @court.save
        render json: @court, status: :created, location: @court
      else
        render json: @court.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /courts/1
    def update
      if @court.update(court_params)
        render json: @court
      else
        render json: @court.errors, status: :unprocessable_entity
      end
    end

    # DELETE /courts/1
    def destroy
      @court.destroy
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_court
        if params[:id] == "load"
          load
        else
          @court = Court.find(params[:id])
        end
      end

      # Only allow a trusted parameter "white list" through.
      def court_params
        params.require(:court).permit(:name, :index, :sbj_id, :sbj_index)
      end
  end
end