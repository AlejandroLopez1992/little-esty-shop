class NagerDateService

  def get_url(url)
    response = HTTParty.get(url)
    JSON.parse(response.body, symbolize_name: true)
  end

  def holidays
    get_url("https://date.nager.at/api/v3/CountryInfo/US")
  end
end