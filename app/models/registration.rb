require 'status'
class Registration < ActiveRecord::Base
	STATUSES = [Status::PENDING, Status::ACCEPTED, Status::DENIED, Status::CANCELLED]

	attr_accessible :code, :email, :name, :show_id, :show, :status

	belongs_to :show
	has_one :movie_suggestion, dependent: :destroy
	has_many :votes, dependent: :destroy
	has_many :seat_reservations, dependent: :destroy

	validates :code, :name, :email, :show, :status, presence: true
	validates :code, uniqueness: true, format: /^[a-z0-9]{4}$/
	validates :name, uniqueness: {scope: [:show_id, :email], case_sensitive: false}
	validates :email, format: /^[a-z0-9\-_.]+@[a-z0-9\-]+(\.[a-z0-9\-]+)+$/
	validates :status, inclusion: STATUSES
	validate :max_two_seats_per_registration, :seats_available

	def email=(email)
		write_attribute(:email, email.downcase)
	end

	protected
	def max_two_seats_per_registration
		errors.add(:base, I18n.t('todo'))	if seat_reservations.length > 2 #TODO
	end

	def seats_available
		seat_reservations.each do |reservation|
			unless show.seat_available?(reservation.seat)
				errors.add(:base, I18n.t("Seat #{reservation.seat.name} is already taken.")) #TODO
			end
		end
	end
end
