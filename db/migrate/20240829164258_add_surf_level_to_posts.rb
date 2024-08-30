class AddSurfLevelToPosts < ActiveRecord::Migration[7.1]
  def change
    add_column :posts, :surf_level, :string
  end
end
