class AddCheckAlertsAtToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :check_alerts_at, :timestamp
  end
end
