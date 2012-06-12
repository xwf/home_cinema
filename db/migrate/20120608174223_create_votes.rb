class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.integer :movie_suggestion_id, null: false
      t.integer :registration_id, null: false
      t.integer :points, null: false, default: 0

      t.timestamps
    end
  end
end
