class MovieSearchResult < ActiveRecord::Base
  attr_accessible :movie, :movie_search, :result_number

	validates :movie_search_id, :movie_id, :result_number, presence: true
	validates :result_number, :movie_id,
		uniqueness: {scope: :movie_search_id},
		numericality: {greater_than_or_equal_to: 0}

	belongs_to :movie
	belongs_to :movie_search
end
