module SeatsHelper
	def get_seat_class(seat, registration)
		html_class = 'seat'
		if registration.present?
			html_class += ' selected' if registration.seat_reservations.any? { |sr| sr.seat == seat }
			html_class += ' taken' unless registration.show.seat_available?(seat)
		end
		return html_class
	end
end
