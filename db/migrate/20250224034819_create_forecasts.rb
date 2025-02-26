# frozen_string_literal: true

class CreateForecasts < ActiveRecord::Migration[7.1]
  def change
    create_table :forecasts do |t|
      t.string :address
      t.integer :temperature
      t.integer :high_temperature
      t.integer :low_temperature
      t.datetime :cached_at

      t.timestamps
    end
  end
end
