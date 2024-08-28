class AddWavePeriodToPosts < ActiveRecord::Migration[7.1]
  def change
    rename_column :posts, :wave_period, :wave_period
  end
end
