class CreateShows < ActiveRecord::Migration
  def change
    create_table :shows do |t|
      t.datetime :date
      t.text :text
      t.boolean :movie_suggestions_allowed, default: true

      t.timestamps
    end
  end
end
