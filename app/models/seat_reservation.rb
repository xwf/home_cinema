class SeatReservation < ActiveRecord::Base
  attr_accessible :registration_id, :registration, :seat_id, :seat

	belongs_to :registration
	belongs_to :seat

	validates :seat, presence: true
end
