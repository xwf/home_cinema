class CreateMovieSearches < ActiveRecord::Migration
  def change
    create_table :movie_searches do |t|
      t.string :query
      t.integer :total_results

      t.timestamps
    end

		add_index :movie_searches, :query, unique: true
  end
end
