module Api::V1::Cases
  class CasesController < Api::V1::ApiController
    def index
      sbj = params[:sbj].nil? ? "" : params[:sbj].to_i
      crt = params[:crt].nil? ? "" : params[:crt]
      cn = params[:cn].nil? ? "" : params[:cn]
      prtcnt = params[:prtcnt].nil? ? "" : params[:prtcnt].force_encoding("ASCII-8BIT")
      df = params[:df].nil? ? "" : params[:df]
      dt = params[:dt].nil? ? "" : params[:dt]
      type = params[:type].nil? ? "" : params[:type]
      ctg = params[:ctg].nil? ? "" : params[:ctg]
      ctg_itm = params[:ctg_itm].nil? ? "" : params[:ctg_itm]
      jdg = params[:jdg].nil? ? "" : params[:jdg]

      url="https://sudrf.ru/index.php?id=300&page=0&act=go_sp_search&searchtype=sp&court_subj=#{sbj}&suds_subj=#{crt}&num_d=#{cn}&f_name=#{URI::encode(prtcnt)}&date_num_in=#{df}&date_num_out=#{dt}&suds_vid=#{type}&spkatg=#{ctg_itm}&suds_pip=&st_cat=#{ctg}&sud_pip=#{jdg}"
      unparsed_page = HTTParty.get(url, :verify => false)
      parsed_page = Nokogiri::HTML(unparsed_page)

      cases = Set.new

      div = parsed_page.at('#num2')
      table = div.css('table')
      raws = table.css('tr')

      cases_per_page = raws.count - 1 # 25 after subtract headers tr
      total_cases = parsed_page.css('div.style3').at('//div[4]').text.split(' ')[5].gsub('.','').to_i
      page = 0
      last_page = (total_cases.to_f/cases_per_page.to_f).round

      while page < last_page
        pagination_url = "https://sudrf.ru/index.php?id=300&page=#{page}&act=go_sp_search&searchtype=sp&court_subj=#{sbj}&suds_subj=#{crt}&num_d=#{cn}&f_name=#{URI::encode(prtcnt)}&date_num_in=#{df}&date_num_out=#{dt}&suds_vid=#{type}&spkatg=#{ctg_itm}&suds_pip=&st_cat=#{ctg}&sud_pip=#{jdg}"
        pagination_unparsed_page = HTTParty.get(pagination_url)
        pagination_parsed_page = Nokogiri::HTML(pagination_unparsed_page)

        raws = pagination_parsed_page.at('#num2').css('table').css('tr')
        raws.map do |row|
          values = row.css('td').map(&:text)
          low_case = {
              law: values[0],
              case_number: values[1],
              receipt_date: values[2],
              case_description: values[3],
              judge: values[4],
              hearing_result: values[5],
              acts: values[6]
          }
          cases.add(low_case)
        end

        page += 1
      end

      render json: cases
    end

    private
    # Only allow a trusted parameter "white list" through.
    def court_params
      params.require(:sbj) #subject
      params.require(:crt) #court
      params.require(:prtcnt) #participant_fio
      #params.require(:)

      params.permit(:cn) #case_number
      params.permit(:df, :dt) #date_from, date_to
      params.permit(:type) #type
      params.permit(:ctg) #category
      params.permit(:ctg_itm) #category_item
      params.permit(:jdg) #judge_fio
      #params.permit(:)
    end
  end
end
