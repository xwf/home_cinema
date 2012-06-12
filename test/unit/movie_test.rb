require 'test_helper'

class MovieTest < ActiveSupport::TestCase
	setup do
		@movie = Movie.new(
			title: 'Lost in Translation',
			year: 2004,
			description: 'bla',
			length: 118
		)
	end


  test 'movie attributes must not be empty' do
		movie = Movie.new
		assert movie.invalid?
		assert movie.errors[:title].any?
		assert movie.errors[:year].any?
		assert movie.errors[:description].any?
		assert movie.errors[:length].any?
	end

	test 'title / year must be unique' do
		@movie.title = movies(:matrix).title
		@movie.year = movies(:matrix).year

		assert !@movie.save
		assert @movie.errors[:title].any?
		#assert_equal I18n.translate('activerecord.errors.messages.taken'),
		#	@movie.errors[:title].join('; ')

		@movie.title = @movie.title.downcase
		assert !@movie.save
		assert @movie.errors[:title].any?
		#assert_equal I18n.translate('activerecord.errors.messages.taken'),
		#	@movie.errors[:title].join('; ')

		@movie.year = 2010
		assert @movie.save
	end

	test 'movie length must be at least 10 minutes' do
		@movie.length = 5
		assert @movie.invalid?
		assert @movie.errors[:length].any?

		@movie.length = 10
		assert @movie.valid?
	end

	test 'year must be greater than 1920' do
		@movie.year = 98
		assert @movie.invalid?
		assert @movie.errors[:year].any?

		@movie.year = 1920
		assert @movie.invalid?
		assert @movie.errors[:year].any?

		@movie.year = 1955
		assert @movie.valid?
	end

	test 'year must not be in the future' do
		@movie.year = 2015
		assert @movie.invalid?
		assert @movie.errors[:year].any?

		@movie.year = Date.current.year
		assert @movie.valid?
	end
end
