class CreateSurfspots < ActiveRecord::Migration[7.1]
  def change
    create_table :surfspots do |t|
      t.string :name
      t.string :location
      t.string :image_url

      t.timestamps
    end
  end
end
