class CreateMovieSearchResults < ActiveRecord::Migration
  def change
    create_table :movie_search_results do |t|
      t.integer :result_number
			t.integer :movie_search_id
      t.integer :movie_id

      t.timestamps
    end

		add_index :movie_search_results, [:movie_search_id, :result_number], unique: true
  end
end
