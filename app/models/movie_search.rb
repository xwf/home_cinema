class MovieSearch < ActiveRecord::Base
  attr_accessible :query, :total_results

	has_many :results, class_name: 'MovieSearchResult', order: 'result_number',
										include: :movie, dependent: :destroy

	validates :query, presence: true, uniqueness: {case_sensitive: false}
	validates :total_results, presence: true, numericality: {greater_than: 0}

	def page_count
		(total_results / 5.0).ceil
	end
end
