require 'test_helper'

class MovieSearchTest < ActiveSupport::TestCase
  
	test 'movie search attributes not empty' do
		movie_search = MovieSearch.new
		assert movie_search.invalid?, 'Empty MovieSearch should not be valid'
		assert movie_search.errors[:query].any?, 'Should have errors for query'
		assert movie_search.errors[:total_results].any?, 'Should have errors for total results'
	end

	test 'total results greater than 0' do
		movie_search = MovieSearch.new(query: 'blub', total_results: 0)
		assert movie_search.invalid?, 'MovieSearch with 0 results should be invalid'
		assert movie_search.errors[:total_results].any?, 'Should have errors for total results'

		movie_search.total_results = -5
		assert movie_search.invalid?, 'MovieSearch with negative amount of results should be invalid'
		assert movie_search.errors[:total_results].any?, 'Should have errors for total results'

		movie_search.total_results = 7
		assert movie_search.valid?, 'MovieSearch with positive amount of results should be valid'
	end

	test 'query unique' do
		movie_search = MovieSearch.new(query: 'Angel', total_results: 22)
		assert movie_search.invalid?, 'MovieSearch with query "Angel" should not be valid'
		assert movie_search.errors[:query].any?, 'Should have errors for query'

		movie_search.query = 'tESt'
		assert movie_search.invalid?, 'MovieSearch with query "tESt" should not be valid'
		assert movie_search.errors[:query].any?, 'Should have errors for query'

		movie_search.query = 'blub'
		assert movie_search.valid?, 'MovieSearch with query "blub" should be valid'
	end
	
end