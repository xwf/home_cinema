class CreateMovies < ActiveRecord::Migration
  def change
    create_table :movies do |t|
      t.string :title
      t.text :description
      t.integer :length
      t.integer :year

      t.timestamps
    end
  end
end
