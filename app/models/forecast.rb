# frozen_string_literal: true

class Forecast < ApplicationRecord
  validates :address, presence: true
  validates :temperature, presence: true

  def self.retrieve_forecast_data(address)
    service = OpenWeatherService.new
    service.fetch_forecast(address)
  end

  def self.fetch_forecast(address)
    cache_key = "forecast/#{address}"
    cached_forecast = Rails.cache.read(cache_key)

    return cached_forecast if cached_forecast

    forecast_data = retrieve_forecast_data(address)
    return nil unless forecast_data

    forecast = create(
      address: address,
      temperature: forecast_data[:temperature],
      high_temperature: forecast_data[:high_temperature],
      low_temperature: forecast_data[:low_temperature],
      cached_at: Time.current
    )
    Rails.cache.write(cache_key, forecast, expires_in: 30.minutes)
    forecast
  end
end
