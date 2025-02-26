# frozen_string_literal: true

# filepath: /home/boris/projects/weather2025/app/services/open_weather_service.rb
require 'geocoder'

class OpenWeatherService
  def initialize(api_key = ENV['API_KEY'])
    @client = OpenWeather::Client.new(api_key: api_key)
  end

  def fetch_forecast(address)
    coordinates = geocode_address(address)
    return nil unless coordinates

    response = @client.current_weather(lat: coordinates[:lat], lon: coordinates[:lon], units: 'imperial')
    parse_response(response)
  end

  private

  def geocode_address(address)
    results = Geocoder.search(address)
    return nil if results.empty?

    location = results.first
    {
      lat: location.latitude,
      lon: location.longitude
    }
  end

  def parse_response(response)
    {
      temperature: response['main']['temp'],
      high_temperature: response['main']['temp_max'],
      low_temperature: response['main']['temp_min']
    }
  end
end
