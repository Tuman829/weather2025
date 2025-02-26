# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Forecast, type: :model do
  before do
    Rails.cache.clear
  end

  describe '.retrieve_forecast_data' do
    it 'retrieves forecast data for a given address' do
      address = '123 Main St'
      service = instance_double(OpenWeatherService)
      allow(OpenWeatherService).to receive(:new).and_return(service)
      allow(service).to receive(:fetch_forecast).with(address).and_return(
        temperature: 72,
        high_temperature: 75,
        low_temperature: 65
      )

      forecast_data = Forecast.retrieve_forecast_data(address)
      expect(forecast_data).to include(:temperature, :high_temperature, :low_temperature)
    end
  end

  describe '.fetch_forecast' do
    it 'caches the forecast data for 30 minutes' do
      address = '123 Main St'
      service = instance_double(OpenWeatherService)
      allow(OpenWeatherService).to receive(:new).and_return(service)
      allow(service).to receive(:fetch_forecast).with(address).and_return(
        temperature: 72,
        high_temperature: 75,
        low_temperature: 65
      )

      forecast = Forecast.fetch_forecast(address)
      expect(Rails.cache.read("forecast/#{address}")).to eq(forecast)
    end

    it 'returns cached forecast data if available' do
      address = '123 Main St'
      cached_forecast = Forecast.create(
        address: address,
        temperature: 72,
        high_temperature: 75,
        low_temperature: 65,
        cached_at: Time.current
      )
      Rails.cache.write("forecast/#{address}", cached_forecast, expires_in: 30.minutes)
      forecast = Forecast.fetch_forecast(address)
      expect(forecast).to eq(cached_forecast)
    end
  end
end
