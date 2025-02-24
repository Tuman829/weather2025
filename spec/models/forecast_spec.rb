require 'spec_helper'

RSpec.describe Forecast, type: :model do
  it 'is valid with valid attributes' do
    forecast = Forecast.new(attribute1: 'value1', attribute2: 'value2')
    expect(forecast).to be_valid
  end

  it 'is not valid without attribute1' do
    forecast = Forecast.new(attribute2: 'value2')
    expect(forecast).to_not be_valid
  end

  it 'calculates the correct value' do
    forecast = Forecast.new(attribute1: 'value1', attribute2: 'value2')
    expect(forecast.calculate_value).to eq(expected_value)
  end
end