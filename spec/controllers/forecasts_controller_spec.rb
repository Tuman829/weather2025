# filepath: /home/boris/projects/weather2025/spec/controllers/forecasts_controller_spec.rb
require 'rails_helper'

RSpec.describe ForecastsController, type: :controller do
  describe 'GET #new' do
    it 'returns a success response' do
      get :new
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    context 'when forecast data is retrieved successfully' do
      before do
        allow(controller).to receive(:retrieve_forecast_data).and_return(
          temperature: 72,
          high_temperature: 75,
          low_temperature: 65
        )
      end

      it 'creates a new forecast and renders the show template' do
        post :create, params: { forecast: { address: '123 Main St' } }
        expect(response).to render_template(:show)
        expect(assigns(:forecast)).to be_a(Forecast)
        expect(assigns(:forecast)).to be_persisted
      end
    end

    context 'when forecast data is not retrieved' do
      before do
        allow(controller).to receive(:retrieve_forecast_data).and_return(nil)
      end

      it 'renders the new template with an error message' do
        post :create, params: { forecast: { address: '123 Main St' } }
        expect(response).to render_template(:new)
        expect(flash[:error]).to eq('Could not retrieve forecast data.')
      end
    end
  end
end