class CreateMovies < ActiveRecord::Migration
  def change
    create_table :movies do |t|      
			t.string :title
      t.text :description
      t.integer :runtime
      t.integer :production_year
			t.string :moviepilot_url
			t.string :moviepilot_image_url
			t.has_attached_file :poster

      t.timestamps
    end

		add_index :movies, :moviepilot_url, unique: true
  end
end
