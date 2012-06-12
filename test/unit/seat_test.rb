require 'test_helper'

class SeatTest < ActiveSupport::TestCase
	test 'name must not be empty' do
		seat = Seat.new
		assert seat.invalid?, 'Seat should be invalid'
		assert seat.errors[:name].any?, 'An error should be present'
	end

	test 'name must be unique' do
		seat = Seat.new(name: 'Seat 1')
	end
end
