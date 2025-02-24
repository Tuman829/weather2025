class CreateForecasts < ActiveRecord::Migration[6.0]
  def change
    create_table :forecasts do |t|
      t.string :address, null: false
      t.float :current_temperature
      t.float :high_temperature
      t.float :low_temperature
      t.datetime :cached_at

      t.timestamps
    end

    add_index :forecasts, :address, unique: true
  end
end