# frozen_string_literal: true

# filepath: /home/boris/projects/weather2025/spec/services/open_weather_service_spec.rb
require 'rails_helper'

RSpec.describe OpenWeatherService do
  let(:api_key) { 'test_api_key' }
  let(:service) { OpenWeatherService.new(api_key) }
  let(:address) { '123 Main St' }
  let(:coordinates) { { lat: 37.7749, lon: -122.4194 } }
  let(:response) do
    {
      'main' => {
        'temp' => 72,
        'temp_max' => 75,
        'temp_min' => 65
      }
    }
  end

  before do
    allow(Geocoder).to receive(:search).with(address).and_return([double(latitude: coordinates[:lat],
                                                                         longitude: coordinates[:lon])])
    allow(service).to receive(:parse_response).and_return(
      temperature: 72,
      high_temperature: 75,
      low_temperature: 65
    )
  end

  describe '#fetch_forecast' do
    it 'fetches forecast data for a given address' do
      allow(service.instance_variable_get(:@client)).to receive(:current_weather).with(lat: coordinates[:lat],
                                                                                       lon: coordinates[:lon]).and_return(response)

      forecast_data = service.fetch_forecast(address)
      expect(forecast_data).to include(:temperature, :high_temperature, :low_temperature)
      expect(forecast_data[:temperature]).to eq(72)
      expect(forecast_data[:high_temperature]).to eq(75)
      expect(forecast_data[:low_temperature]).to eq(65)
    end

    it 'returns nil if geocoding fails' do
      allow(Geocoder).to receive(:search).with(address).and_return([])

      forecast_data = service.fetch_forecast(address)
      expect(forecast_data).to be_nil
    end
  end
end
