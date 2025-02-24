class ForecastsController < ApplicationController
  def new
    @forecast = Forecast.new
  end

  def create
    address = forecast_params[:address]
    @forecast = fetch_forecast(address)

    if @forecast
      render :show
    else
      flash[:error] = "Could not retrieve forecast data."
      render :new
    end
  end

  private

  def forecast_params
    params.require(:forecast).permit(:address)
  end

  def fetch_forecast(address)
    cache_key = "forecast/#{address}"
    cached_forecast = Rails.cache.read(cache_key)

    if cached_forecast
      @from_cache = true
      return cached_forecast
    end

    @from_cache = false
    forecast_data = retrieve_forecast_data(address)

    if forecast_data
      forecast = Forecast.create(
        address: address,
        temperature: forecast_data[:temperature],
        high_temperature: forecast_data[:high_temperature],
        low_temperature: forecast_data[:low_temperature],
        cached_at: Time.current
      )
      Rails.cache.write(cache_key, forecast, expires_in: 30.minutes)
      forecast
    else
      nil
    end
  end

  def retrieve_forecast_data(address)
    # Implement the logic to call the weather API and retrieve forecast data
    # This should return a hash containing the forecast details
    # Example response structure:
    # {
    #   temperature: 72,
    #   high_temperature: 75,
    #   low_temperature: 65
    # }
    # For now, we'll return a mock response
    {
      temperature: 72,
      high_temperature: 75,
      low_temperature: 65
    }
  end
end
