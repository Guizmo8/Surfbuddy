class CreatePosts < ActiveRecord::Migration[7.1]
  def change
    create_table :posts do |t|
      t.references :surfspot, null: false, foreign_key: true
      t.string :wave_period
      t.string :wave_direction
      t.string :wind
      t.string :wind_direction
      t.string :ripple
      t.string :sea_temperature
      t.string :tide

      t.timestamps
    end
  end
end
