class Forecast < ApplicationRecord
  # Attributes for the forecast data
  attr_accessor :current_temperature, :high_temperature, :low_temperature, :cached_at

  # Method to retrieve forecast data from the weather API
  def self.fetch_forecast(address)
    # Logic to call the weather API and retrieve forecast data
    # This is a placeholder for the actual API call
    response = WeatherApiService.get_forecast(address)

    if response.success?
      forecast_data = response.data
      forecast = Forecast.new
      forecast.current_temperature = forecast_data[:current_temperature]
      forecast.high_temperature = forecast_data[:high_temperature]
      forecast.low_temperature = forecast_data[:low_temperature]
      forecast.cached_at = Time.current
      forecast.save
      forecast
    else
      nil
    end
  end

  # Method to check if the forecast is cached and still valid
  def self.cached_forecast(zip_code)
    forecast = Forecast.find_by(zip_code: zip_code)
    return forecast if forecast && forecast.cached_at > 30.minutes.ago

    nil
  end
end