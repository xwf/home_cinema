require 'status'
class Registration < ActiveRecord::Base
	STATUSES = [Status::PENDING, Status::ACCEPTED, Status::DENIED, Status::CANCELLED]

	attr_accessible :code, :email, :name, :show_id, :show, :status, :seat_id

	belongs_to :show
	has_one :movie_suggestion, dependent: :destroy
	has_many :votes, dependent: :destroy
	has_many :seat_reservations, dependent: :destroy

	validates :code, :name, :email, :show, :status, presence: true
	validates :code, uniqueness: true, format: /^[a-z0-9]{4}$/
	validates :name, uniqueness: {scope: [:show_id, :email], case_sensitive: false}
	validates :email, format: /^[a-z0-9\-_.]+@[a-z0-9\-]+(\.[a-z0-9\-]+)+$/
	validates :status, inclusion: STATUSES
	validate :seat_reservation_count, :seats_available

	def email=(email)
		write_attribute(:email, email.downcase)
	end

	def seat_id=(seat_id)
		seat_reservations.build(seat_id: seat_id)
	end

	def seat_id
		seat_reservations.first.seat_id unless seat_reservations.empty?
	end

	protected
	def seat_reservation_count
		unless validation_context.nil?
			if seat_reservations.length < 1
				errors.add(:base, "Bitte w&auml;hle einen freien Platz aus.".html_safe)
			elsif seat_reservations.length > 2
				errors.add(:base, 'Du kannst maximal 2 Pl&auml;tze reservieren.'.html_safe)
			end
		end
	end

	def seats_available
		seat_reservations.each do |reservation|
			unless show.nil? or show.seat_available?(reservation.seat)
				errors.add(:base, "Da war wohl jemand schneller...\n"+
						"Der Platz #{reservation.seat.name} ist bereits reserviert worden. "+
						'Bitte w&auml;hle einen anderen!'.html_safe)
			end
		end
	end
end
