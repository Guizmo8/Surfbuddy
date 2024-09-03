class ChangesToUsers < ActiveRecord::Migration[7.1]
  def change
    remove_column :users, :alert_preferences
    add_column :users, :alert_start_time, :time
    add_column :users, :alert_end_time, :time
  end
end
