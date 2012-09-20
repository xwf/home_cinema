class Movie < ActiveRecord::Base
  attr_accessible :description, :runtime, :title, :production_year,
									:poster, :moviepilot_url, :moviepilot_image_url

	has_many :movie_suggestions, dependent: :destroy
	has_attached_file :poster,
										styles: { poster: '60', normal: '200' },
										path: ':rails_root/public/system/:class/:attachment/:id/:style/:filename',
										url: '/system/:class/:attachment/:id/:style/:filename'

	validates :title, :description, presence: true
	validates :runtime, :production_year, presence: true, unless: :api_result?
	validates :runtime, numericality: {greater_than_or_equal_to: 10}, unless: :api_result?
	validates :production_year, numericality: {greater_than: 1920,
																	less_than_or_equal_to: Date.current.year}, unless: :api_result?
	validates :moviepilot_url, format: %r{^http://www\.moviepilot\.de/movies/[^/]+$},
														uniqueness: true, allow_nil: true
	validate :not_from_moviepilot, on: :update

	def self.build_from_api_result(movie_data)
		movie = self::find_or_initialize_by_moviepilot_url(movie_data['restful_url'])
		movie.assign_attributes(
			title: CGI::unescape_html(movie_data['display_title']),
			description: self::convert_description(movie_data['plain_short_description']),
			runtime: movie_data['runtime'],
			production_year: movie_data['production_year'],
			moviepilot_image_url: self::poster_url(movie_data['poster']))
		return movie
	end

	private
	def self.poster_url(pd)
		"#{pd['base_url']+pd['photo_id']}/#{pd['file_name_base']}.#{pd['extension']}" if pd.is_a? Hash
	end

	def self.convert_description(description)
		return 'Keine Beschreibung' if description.blank?
		CGI::unescape_html(description)
		.gsub(/(\()?"(.+?) \(\2\)":/) { if $1 then "(#{$2})" else $2 end }
	end

	def api_result?
		not moviepilot_url.nil?
	end

	def not_from_moviepilot
		errors.add(:base, I18n::t('activerecord.errors.messages.cannot_update')) if moviepilot_url.present?
	end
end
