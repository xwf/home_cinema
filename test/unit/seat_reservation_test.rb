require 'test_helper'

class SeatReservationTest < ActiveSupport::TestCase

	test 'seat must exist' do
		sr = SeatReservation.new
		assert sr.invalid?
		assert sr.errors[:seat].any?

		sr.seat_id = 12345
		assert sr.invalid?
		assert sr.errors[:seat].any?
	end
end
