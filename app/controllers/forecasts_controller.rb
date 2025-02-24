class ForecastsController < ApplicationController
  before_action :set_cache_key, only: [:show]

  def create
    # This action can be used to accept an address input
    # Implementation can be added as needed
  end

  def show
    address = params[:address]
    forecast = Rails.cache.fetch(@cache_key, expires_in: 30.minutes) do
      fetch_forecast_data(address)
    end

    if forecast
      render :show, locals: { forecast: forecast, from_cache: Rails.cache.exist?(@cache_key) }
    else
      render json: { error: 'Forecast data not found' }, status: :not_found
    end
  end

  private

  def set_cache_key
    @cache_key = "forecast/#{params[:address]}"
  end

  def fetch_forecast_data(address)
    # Logic to call the weather API and retrieve forecast data
    # This should return a hash or object containing the forecast details
    # Example response structure:
    # {
    #   current_temperature: 72,
    #   high_temperature: 75,
    #   low_temperature: 65,
    #   extended_forecast: [...]
    # }
  end
end