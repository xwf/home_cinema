class CreateSeats < ActiveRecord::Migration
  def change
    create_table :seats do |t|
      t.string :name
      t.string :image_path_free
      t.string :image_path_selected
      t.string :image_path_taken
      t.decimal :position_x, precision: 8, scale: 3
      t.decimal :position_y, precision: 8, scale: 3

      t.timestamps
    end
  end
end
