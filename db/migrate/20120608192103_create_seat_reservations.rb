class CreateSeatReservations < ActiveRecord::Migration
  def change
    create_table :seat_reservations do |t|
      t.integer :registration_id
      t.integer :seat_id

      t.timestamps
    end
  end
end
