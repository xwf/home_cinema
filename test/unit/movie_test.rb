require 'test_helper'

class MovieTest < ActiveSupport::TestCase
	setup do
		@movie = Movie.new(
			title: 'Lost in Translation',
			production_year: 2004,
			description: 'bla',
			runtime: 118
		)
	end


  test 'movie attributes must not be empty' do
		movie = Movie.new
		assert movie.invalid?
		assert movie.errors[:title].any?
		assert movie.errors[:production_year].any?
		assert movie.errors[:description].any?
		assert movie.errors[:runtime].any?
	end

	test 'movie runtime must be at least 10 minutes' do
		@movie.runtime = 5
		assert @movie.invalid?, 'Should not be valid'
		assert @movie.errors[:runtime].any?, 'Should have an error for attribute runtime'

		@movie.runtime = 10
		assert @movie.valid?, 'Should be valid'
	end

	test 'production year must be greater than 1920' do
		@movie.production_year = 98
		assert @movie.invalid?
		assert @movie.errors[:production_year].any?

		@movie.production_year = 1920
		assert @movie.invalid?
		assert @movie.errors[:production_year].any?

		@movie.production_year = 1955
		assert @movie.valid?
	end

	test 'production year must not be in the future' do
		@movie.production_year = 2015
		assert @movie.invalid?
		assert @movie.errors[:production_year].any?

		@movie.production_year = Date.current.year
		assert @movie.valid?
	end

	test 'moviepilot url must be unique' do
		@movie.moviepilot_url = 'http://www.moviepilot.de/movies/matrix'
		assert @movie.invalid?, 'Should not be valid'
		assert @movie.errors[:moviepilot_url].any?, 'Should have an error for attribute moviepilot_url'

		@movie.moviepilot_url = 'http://www.moviepilot.de/movies/lost-in-translation'
		assert @movie.valid?, 'Should be valid'
	end
end
