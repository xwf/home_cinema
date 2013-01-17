class CreateSeats < ActiveRecord::Migration
  def change
    create_table :seats do |t|
      t.string :name
      t.integer :position_x, default: 0
      t.integer :position_y, default: 0
      t.has_attached_file :image
			t.text :image_meta

      t.timestamps
    end
  end
end
