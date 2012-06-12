class Movie < ActiveRecord::Base
  attr_accessible :description, :length, :title, :year

	has_many :movie_suggestions, dependent: :destroy

	validates :title, :year, :length, :description, presence: true
	validates :length, numericality: {greater_than_or_equal_to: 10}
	validates :year, numericality: {greater_than: 1920,
																	less_than_or_equal_to: Date.current.year}
	validates :title, uniqueness: {scope: :year, case_sensitive: false}

end
