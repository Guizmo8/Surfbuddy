class CreatePosts < ActiveRecord::Migration[7.1]
  def change
    create_table :posts do |t|
      t.references :surfspot, null: false, foreign_key: true
      t.text :description
      t.datetime :post_time
      t.float :wave_height
      t.string :wind_direction
      t.float :wave_period
      t.float :number_of_waves_per_minute
      t.float :wave_max_length
      t.float :wave_average_length
      t.float :number_of_rideable_waves_per_minute

      t.timestamps
    end
  end
end
