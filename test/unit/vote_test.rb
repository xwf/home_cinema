require 'test_helper'

class VoteTest < ActiveSupport::TestCase
  test 'vote must not be empty' do
		vote = Vote.new
		assert vote.invalid?, 'Should not be valid'
		assert vote.errors[:registration].any?, 'Should have errors for registration'
		assert vote.errors[:movie_suggestion].any?, 'Should have errors for movie suggestion'
	end

	test 'registration and movie suggestion must exist' do
		vote = Vote.new(
			registration_id: 12345,
			movie_suggestion_id: 54321,
			points: 0
		)
		assert vote.invalid?, 'Should not be valid'
		assert vote.errors[:registration].any?, 'Should have errors for registration'
		assert vote.errors[:movie_suggestion].any?, 'Should have errors for movie suggestion'
	end

	test 'points must not have an invalid value' do
		vote = Vote.new(
			registration: registrations(:joe),
			movie_suggestion: movie_suggestions(:one),
			points: 15
		)
		assert vote.invalid?, 'Should not be valid'
		assert vote.errors[:points].any?, 'Should have errors for points'
	end
end
