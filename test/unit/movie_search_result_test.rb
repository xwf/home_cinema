require 'test_helper'

class MovieSearchResultTest < ActiveSupport::TestCase
  setup do
		@msr = MovieSearchResult.new(
			movie_search: movie_searches(:two),
			movie: movies(:oben),
			result_number: 0
		)
	end
	
	test 'attributes not empty' do
		msr = MovieSearchResult.new
		assert msr.invalid?, 'Empty MovieSearchResult should be invalid'
		assert msr.errors[:movie_search_id].any?, 'Should have errors for movie search id'
		assert msr.errors[:movie_id].any?, 'Should have errors for movie id'
		assert msr.errors[:result_number].any?, 'Should have errors for result number'
	end

	test 'result number not negative' do
		@msr.result_number = -1
		assert @msr.invalid?, 'MovieSearchResult with negative result number should be invalid'
		assert @msr.errors[:result_number].any?, 'Should have errors for result number'

		@msr.result_number = 0
		assert @msr.valid?, 'MovieSearchResult with result number 0 should be valid'
	end

	test 'result number unique per query' do
		assert @msr.valid?, 'Should be valid'

		@msr.movie_search = movie_searches(:one)
		assert @msr.invalid?, 'MovieSearchResult with duplicate result number should be invalid'
		assert @msr.errors[:result_number].any?, 'Should have errors for result number'

		@msr.result_number = 2
		assert @msr.valid?, 'Should be valid'
	end

	test 'movie unique per query' do
		msr = MovieSearchResult.new(
			movie_search: movie_searches(:one),
			result_number: 7
		)

		msr.movie = movies(:blade)
		assert msr.invalid?, 'MovieSearchResult with duplicate movie should be invalid'
		assert msr.errors[:movie_id].any?, 'Should have errors for movie id'

		msr.movie = movies(:oben)
		assert msr.valid?, 'Should be valid'

		@msr.movie = movies(:blade)
		assert @msr.valid?, 'Should be valid'
	end


end
