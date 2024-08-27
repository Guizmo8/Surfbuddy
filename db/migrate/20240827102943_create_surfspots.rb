class CreateSurfspots < ActiveRecord::Migration[7.1]
  def change
    create_table :surfspots do |t|
      t.string :name
      t.string :address
      t.string :break_type
      t.string :photo

      t.timestamps
    end
  end
end
