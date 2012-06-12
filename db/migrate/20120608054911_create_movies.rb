class CreateMovies < ActiveRecord::Migration
  def change
    create_table :movies do |t|
      t.string :title
      t.text :description
      t.integer :length
      t.integer :year
			t.string :image_url

      t.timestamps
    end
  end
end
