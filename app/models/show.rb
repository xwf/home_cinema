require 'status'
class Show < ActiveRecord::Base
  attr_accessible :date, :movie_suggestions_allowed, :text

	has_many :registrations, dependent: :destroy
	has_many :accepted_registrations, class_name: 'Registration',
		conditions: {status: Status::ACCEPTED}
	has_many :pending_registrations, class_name: 'Registration',
		conditions: {status: Status::PENDING}
	has_many :cancelled_registrations, class_name: 'Registration',
		conditions: {status: Status::CANCELLED}
	has_many :denied_registrations, class_name: 'Registration',
		conditions: {status: Status::DENIED}

	has_many :movie_suggestions, dependent: :destroy
	has_many :accepted_user_suggestions, class_name: 'MovieSuggestion',
		conditions: "registration_id IS NOT NULL AND status == '#{Status::ACCEPTED}'"
	has_many :pending_user_suggestions, class_name: 'MovieSuggestion',
		conditions: "registration_id IS NOT NULL AND status == '#{Status::PENDING}'"
	has_many :own_suggestions, class_name: 'MovieSuggestion',
		conditions: {registration_id: nil, status: Status::ACCEPTED}


	belongs_to :featured_movie, class_name: 'Movie'
	has_many :votes, through: :registrations
	has_many :seat_reservations, through: :registrations

	validate :date_in_future

	def available_seats
		return Seat.all - seat_reservations.map {|sr| sr.seat}
	end

	def seat_available?(seat)
		return available_seats.include? seat
	end
	

	protected

	def date_in_future
		if date.nil?
			errors.add(:date, :blank)
		else
			errors.add(:date, 'Das Datum muss in der Zukunft liegen.') unless date > DateTime.current
		end
	end
end
