require 'status'
class MovieSuggestion < ActiveRecord::Base
	STATUSES = [Status::PENDING, Status::ACCEPTED, Status::DENIED]

  attr_accessible :comment, :movie_id, :registration_code, :show_id,
									:movie, :registration, :show, :status

	belongs_to :movie
	belongs_to :registration
	belongs_to :show
	has_many :votes, dependent: :destroy

	validates :show, presence: true
	validates :movie, presence: {message: I18n.t('activerecord.errors.messages.no_movie')}
	validates :movie_id, uniqueness: {scope: :show_id, message: I18n.t('activerecord.errors.messages.duplicate_movie')}
	validates :status, inclusion: STATUSES
	validate :suggestions_allowed_for_show

	def registration_code=(code)
		self.registration = Registration.find_by_code(code)
	end

	def registration_code
		registration.code unless registration.nil?
	end

	protected
	def suggestions_allowed_for_show
		if registration
			errors.add(:base, I18n.t('activerecord.errors.messages.no_suggestions_allowed')) unless show.movie_suggestions_allowed
		end
	end
end
