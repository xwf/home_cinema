class AddIndexForMoviepilotUrlToMovies < ActiveRecord::Migration
  def change
		add_index :movies, :moviepilot_url, unique: true
  end
end