require 'test_helper'

class MovieSuggestionTest < ActiveSupport::TestCase

	test 'movie and show must exist' do
		ms = MovieSuggestion.new
		assert ms.invalid?, 'Should not be valid'
		assert ms.errors[:show].any?
		assert ms.errors[:movie].any?
		assert ms.errors[:status].any?

		ms2 = MovieSuggestion.new(
			movie_id: 12345,
			show_id: 54321,
			status: Status::PENDING
		)
		assert ms2.invalid?, 'Should not be valid'
		assert ms2.errors[:show].any?
		assert ms2.errors[:movie].any?
	end

	test 'movie can only be suggested once per show' do
		ms = MovieSuggestion.new(
			movie: movies(:blade),
			show: shows(:one),
			status: Status::PENDING
		)
		assert !ms.save, 'Should not save'
		assert ms.errors[:movie_id].any?, 'Should have errors for movie id'
		#assert_equal I18n.t('activerecord.errors.messages.taken'),
		#	ms.errors[:movie_id].join('; ')

		ms2 = shows(:one).movie_suggestions.build(
			movie: movies(:blade),
			status: Status::ACCEPTED
		)
		assert !ms2.save, 'Should not save'
		assert ms.errors[:movie_id].any?, 'Should have errors for movie id'
		#assert_equal I18n.t('activerecord.errors.messages.taken'),
		#	ms2.errors[:movie_id].join('; ')
	end

	test 'no user suggestions if not allowed for show' do
		ms = registrations(:jane).build_movie_suggestion(
			show: registrations(:jane).show,
			movie: movies(:matrix),
			status: Status::PENDING
		)
		assert !ms.save, 'Should not save'
		assert ms.errors[:base].any?

		ms2 = registrations(:joe).build_movie_suggestion(
			show: registrations(:joe).show,
			movie: movies(:matrix),
			status: Status::PENDING
		)
		assert ms2.save, 'Should save'

		ms3 = shows(:two).movie_suggestions.build(
			movie: movies(:blade),
			status: Status::DENIED
		)
		assert ms3.save, 'Should save'
	end

	test 'status must have one of the predefined values' do
		ok = MovieSuggestion::STATUSES
		nok = %w{blub PENDING Accepted dEnIeD cancelled}

		ms = MovieSuggestion.new(
			registration: registrations(:joe),
			show: registrations(:joe).show,
			movie: movies(:matrix)
		)

		ok.each do |status|
			ms.status = status
			assert ms.valid?, "#{status} should not be invalid"
		end

		nok.each do |status|
			ms.status = status
			assert ms.invalid?, "#{status} should not be valid"
			assert ms.errors[:status].any?
		end
	end
end
