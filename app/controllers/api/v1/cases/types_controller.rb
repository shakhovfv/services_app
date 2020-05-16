module Api::V1::Cases
  class TypesController < Api::V1::ApiController
    before_action :set_type, only: [:show, :update, :destroy]

    # GET /types
    def index
      #@types = Type.all
      @types = JSON([{ :value => "ud", :text => "Уголовные дела" },
                     { :value => "gd", :text => "Категория гражданского и административного дела" },
                     { :value => "ad", :text => "Дела об административных правонарушениях" },
                     { :value => "pm", :text => "Производства по материалам" }])

      render json: @types
    end

    # GET /types/1
    def show
      render json: @type
    end

    # POST /types
    def create
      @type = Type.new(type_params)

      if @type.save
        render json: @type, status: :created, location: @type
      else
        render json: @type.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /types/1
    def update
      if @type.update(type_params)
        render json: @type
      else
        render json: @type.errors, status: :unprocessable_entity
      end
    end

    # DELETE /types/1
    def destroy
      @type.destroy
    end

    private
    # Use callbacks to share common setup or constraints between actions.
    def set_type
      @type = Type.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def type_params
      params.require(:type).permit(:name, :index)
    end
  end
end
