# frozen_string_literal: true

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
      flash[:error] = 'Could not retrieve forecast data.'
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

    return cached_forecast if cached_forecast

    forecast_data = Forecast.retrieve_forecast_data(address)
    return nil unless forecast_data

    forecast = Forecast.create(
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
