class AddAlertPreferencesToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :alert_preferences, :jsonb, default: {}
  end
end
