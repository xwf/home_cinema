class CreateMovieSuggestions < ActiveRecord::Migration
  def change
    create_table :movie_suggestions do |t|
      t.integer :movie_id, null: false
      t.integer :show_id, null: false
      t.integer :registration_id
      t.text :comment

      t.timestamps
    end
  end
end
