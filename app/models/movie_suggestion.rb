class MovieSuggestion < ActiveRecord::Base
  attr_accessible :comment, :movie_id, :registration_id, :show_id,
									:movie, :registration, :show

	belongs_to :movie
	belongs_to :registration
	belongs_to :show
	has_many :votes, dependent: :destroy

	validates :movie, :show, presence: true
	validates :movie_id, uniqueness: {scope: :show_id}
	validate :suggestions_allowed_for_show

	protected
	def suggestions_allowed_for_show
		if registration
			errors.add(:base, I18n.t('todo')) unless show.movie_suggestions_allowed #TODO
		end
	end
end
