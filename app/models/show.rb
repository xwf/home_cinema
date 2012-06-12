class Show < ActiveRecord::Base
  attr_accessible :date, :movie_suggestions_allowed, :text

	has_many :registrations, dependent: :destroy
	has_many :movie_suggestions, dependent: :destroy
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
			errors.add(:date, I18n.t('future')) unless date > Date.current #TODO
		end
	end
end
