require 'test_helper'

class ShowTest < ActiveSupport::TestCase
  test 'date must be in the future' do
		show = Show.new(date: '2012-02-26 19:00:00')
		assert show.invalid?, 'Show should not be valid'
		assert_equal 'muss in der Zukunft liegen.', show.errors[:date].join('; ')

		assert !show.update_attributes(date: DateTime.current), 'Update should fail'
		assert_equal 'muss in der Zukunft liegen.', show.errors[:date].join('; ')
	end

	test 'date must be present' do
		show = Show.new
		assert show.invalid?, 'Show should not be valid'
		assert show.errors[:date].any?
	end

	test 'registration filters' do
		show = shows(:one)

		assert_equal show.accepted_registrations.length, 2
		assert_includes show.accepted_registrations, registrations(:jack)
		assert_includes show.accepted_registrations, registrations(:jeff)

		assert_equal show.pending_registrations.length, 1
		assert_includes show.pending_registrations, registrations(:joe)

		assert_equal show.cancelled_registrations.length, 1
		assert_includes show.cancelled_registrations, registrations(:jill)

		assert_equal show.denied_registrations.length, 1
		assert_includes show.denied_registrations, registrations(:jim)
	end

	test 'movie suggestion filters' do
		show = shows(:one)

		assert_equal show.accepted_user_suggestions.length, 2
		assert_includes show.accepted_user_suggestions, movie_suggestions(:three)
		assert_includes show.accepted_user_suggestions, movie_suggestions(:four)

		assert_equal show.pending_user_suggestions.length, 1
		assert_includes show.pending_user_suggestions, movie_suggestions(:two)

		assert_equal show.own_suggestions.length, 1
		assert_includes show.own_suggestions, movie_suggestions(:one)
	end
end
