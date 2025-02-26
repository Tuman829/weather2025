# frozen_string_literal: true

# filepath: /home/boris/projects/weather2025/spec/controllers/forecasts_controller_spec.rb
require 'rails_helper'

RSpec.describe ForecastsController, type: :controller do
  before do
    Rails.cache.clear
  end

  describe 'GET #new' do
    it 'returns a success response' do
      get :new
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    context 'when forecast data is retrieved successfully' do
      before do
        allow(Forecast).to receive(:retrieve_forecast_data).and_return(
          temperature: 72,
          high_temperature: 75,
          low_temperature: 65
        )
      end

      it 'creates a new forecast and responds with success' do
        expect do
          post :create, params: { forecast: { address: '123 Main St' } }
        end.to change(Forecast, :count).by(1)
        expect(response).to have_http_status(:ok)
        expect(response.body).to include('Forecast for 123 Main St')
        expect(response.body).to include('72°F')
      end
    end

    context 'when forecast data is not retrieved' do
      before do
        allow(Forecast).to receive(:retrieve_forecast_data).and_return(nil)
      end

      it 'renders the new template with an error message' do
        post :create, params: { forecast: { address: '123 Main St' } }
        expect(response).to have_http_status(:ok)
        expect(flash[:error]).to eq('Could not retrieve forecast data.')
        expect(response.body).to include('New Forecast') # Example: Check for a heading in the `new` template
      end
    end
  end
end
