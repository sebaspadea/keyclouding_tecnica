class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home ]

  def home
    @data = JSON.parse(fetch_data())
    token = @data["token"]
    @ks = JSON.parse(fetch_ks(token))
    ks_codes = []
    @ks["ks_list"].each { |k| ks_codes << k["ks_code"] }
    @postulante = JSON.parse(fetch_postulante(token, ks_codes[0]))
    @resultados = JSON.parse(fetch_resultados(token,@postulante["ks_id"]))
  end

  def fetch_data
    url = 'https://staging.keyclouding.cl/api/v1/company/authentication'
    RestClient.post( url,
    {
      :secret => ENV["API_KEY_KEYCLOUDING"],
    })
  end

  def fetch_ks(token)
    url = "https://staging.keyclouding.cl/api/v1/company/list_ks"
    RestClient.post( url,
    {
      :token => token
    })
  end
  
  def fetch_postulante(token,ks_code)
    url = "https://staging.keyclouding.cl/api/v1/company/assign_ks"
    RestClient.post( url,
    {
      :token => token,
      :dni => 13433615, 
      :ks_code => ks_code,
      :country => "CL",
      :nombres => "Juan",
      :apellido_paterno => "Perez",
      :email => "juan@perez.cl",
      :proceso => "DESARROLLADOR"
    })
  end

  def fetch_resultados(token,ks_id)
    url = "https://staging.keyclouding.cl/api/v1/company/results_ks"
    RestClient.post( url,
    {
      :token => token,
      :ks_id => ks_id
    })
  end
end
