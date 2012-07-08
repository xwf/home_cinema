class Movie < ActiveRecord::Base
  attr_accessible :description, :runtime, :title, :production_year, :image_url, :moviepilot_url

	has_many :movie_suggestions, dependent: :destroy

	validates :title, :production_year, :runtime, :description, presence: true
	validates :runtime, numericality: {greater_than_or_equal_to: 10}
	validates :production_year, numericality: {greater_than: 1920,
																	less_than_or_equal_to: Date.current.year}
	validates :title, uniqueness: {scope: :production_year, case_sensitive: false}
	validates :moviepilot_url, uniqueness: true, allow_nil: true

end
