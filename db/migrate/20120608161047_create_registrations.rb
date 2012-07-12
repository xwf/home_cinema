class CreateRegistrations < ActiveRecord::Migration
  def change
    create_table :registrations do |t|
      t.string :code, limit: 4, null: false
			t.string :name
      t.string :email
			t.string :status
      t.integer :show_id, null: false

      t.timestamps
    end

		add_index :registrations, :code, unique: true
  end
end
