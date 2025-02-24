require 'rails_helper'

RSpec.describe ForecastsController, type: :controller do
  describe 'GET #index' do
    it 'returns a success response' do
      get :index
      expect(response).to be_successful
    end
  end

  describe 'GET #show' do
    it 'returns a success response' do
      forecast = Forecast.create!(attributes_for(:forecast))
      get :show, params: { id: forecast.to_param }
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    it 'creates a new forecast' do
      expect {
        post :create, params: { forecast: attributes_for(:forecast) }
      }.to change(Forecast, :count).by(1)
    end
  end

  describe 'PATCH #update' do
    it 'updates the requested forecast' do
      forecast = Forecast.create!(attributes_for(:forecast))
      patch :update, params: { id: forecast.to_param, forecast: { name: 'Updated Name' } }
      forecast.reload
      expect(forecast.name).to eq('Updated Name')
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested forecast' do
      forecast = Forecast.create!(attributes_for(:forecast))
      expect {
        delete :destroy, params: { id: forecast.to_param }
      }.to change(Forecast, :count).by(-1)
    end
  end
end