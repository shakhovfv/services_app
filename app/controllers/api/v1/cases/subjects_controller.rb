module Api::V1::Cases
  class SubjectsController < Api::V1::ApiController
    before_action :set_subject, only: [:show, :update, :destroy]

    # GET /subjects
    def index
      @subjects = Subject.all

      render json: @subjects
    end

    # GET /subjects/1
    def show
      render json: @subject
    end

    # POST /subjects/load
    # curl -H "Authorization: Token token=JsRIbhB8kcbw4MaIYrcjsAtt" -X GET http://localhost:3000/v1/subjects/load
    def load
      url = "https://sudrf.ru/index.php?id=300#sp"
      unparsed_page = HTTParty.get(url, :verify => false)
      parsed_page = Nokogiri::HTML(unparsed_page)
      list = parsed_page.css('#court_subj option')
      count = list.count

      i = 1
      while i < count
        if Subject.find_by_index(list[i].values[0].to_i).nil?
          @subject = Subject.create(name: list[i].text, index: list[i].values[0])
        end
        i += 1
      end

      render json: @count, status: :created, location: @subject
    end

    # POST /subjects
    def create
      @subject = Subject.new(subject_params)

      if @subject.save
        render json: @subject, status: :created, location: @subject
      else
        render json: @subject.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /subjects/1
    def update
      if @subject.update(subject_params)
        render json: @subject
      else
        render json: @subject.errors, status: :unprocessable_entity
      end
    end

    # DELETE /subjects/1
    def destroy
      @subject.destroy
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_subject
        if params[:id] == "load"
          load
        else
          @subject = Subject.find(params[:id])
        end
      end

      # Only allow a trusted parameter "white list" through.
      def subject_params
        params.require(:subject).permit(:name, :index)
      end
  end
end