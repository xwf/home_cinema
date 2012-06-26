class AddIndexForCodeToRegistrations < ActiveRecord::Migration
  def change
		add_index :registrations, :code
  end
end
