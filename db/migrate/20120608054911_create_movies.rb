class CreateMovies < ActiveRecord::Migration
  def change
    create_table :movies do |t|      
			t.string :title
      t.text :description
      t.integer :runtime
      t.integer :production_year
			t.string :image_url
			t.string :moviepilot_url

      t.timestamps
    end
  end
end
