class Vote < ActiveRecord::Base
	VOTES = {
		positive: 3,
		neutral: 0,
		negative: -4
	}

  attr_accessible :movie_suggestion_id, :movie_suggestion,
		:registration_id, :registration, :points

	belongs_to :movie_suggestion
	belongs_to :registration

	validates :movie_suggestion, :registration, :points, presence: true
	validates :points, inclusion: VOTES.values
	validate :suggestion_and_registration_belong_to_same_show

	protected
	def suggestion_and_registration_belong_to_same_show
		unless registration.nil? or movie_suggestion.nil?
			errors.add(:base, I18n.t('todo')) unless registration.show == movie_suggestion.show #TODO
		end
	end
end
