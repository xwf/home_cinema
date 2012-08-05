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

	test 'production_year and runtime may be empty for api results' do
		api_movie = Movie.new(
			title: 'Test',
			description: 'blub',
			moviepilot_url: 'http://www.moviepilot.de/movies/test'
		)

		assert api_movie.valid?, 'Should be valid'
	end

	test 'production_year and runtime may be invalid for api results' do
		api_movie = Movie.new(
			title: 'Test',
			description: 'blub',
			runtime: 5,
			production_year: 2013,
			moviepilot_url: 'http://www.moviepilot.de/movies/test'
		)

		assert api_movie.valid?, 'Should be valid'
	end

	test 'moviepilot_url format' do
		invalid = %w{blub http://www.imdb.org/matrix www.moviepilot.de/movies/matrix
								http://www.moviepilot.de/matrix http://www.moviepilot.de/movies/ca/h
								xhttp://www.moviepilot.de/movies/blub http://www.moviepilot.de/movies/test/
								HTTP://www.Moviepilot.de/Movies/Blade}
		valid = %w{http://www.moviepilot.de/movies/test http://www.moviepilot.de/movies/b5-a_x
							http://www.moviepilot.de/movies/ca$h}

		invalid.each do |url|
			@movie.moviepilot_url = url
			assert @movie.invalid?, "moviepilot url #{url} should be invalid"
		end

		valid.each do |url|
			@movie.moviepilot_url = url
			assert @movie.valid?, "moviepilot url #{url} should be valid"
		end
	end
end
