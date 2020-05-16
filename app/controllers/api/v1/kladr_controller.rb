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
      render :json => reply.body.to_json
    end

    private
    # Only allow a trusted parameter "white list" through.
    def kladr_params
      params.require(:str) #address from user
    end
  end
end