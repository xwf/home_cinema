class Movie < ActiveRecord::Base
  attr_accessible :description, :runtime, :title, :production_year, :image_url, :moviepilot_url

	has_many :movie_suggestions, dependent: :destroy

	validates :title, :production_year, :runtime, :description, presence: true
	validates :runtime, numericality: {greater_than_or_equal_to: 10}
	validates :production_year, numericality: {greater_than: 1920,
																	less_than_or_equal_to: Date.current.year}
	validates :title, uniqueness: {scope: :production_year, case_sensitive: false}
	validates :moviepilot_url, uniqueness: true, allow_nil: true

	def self.build_from_api_result(movie_data)
		movie = self::find_or_initialize_by_moviepilot_url(movie_data['restful_url'])
		movie.update_attributes(
			title: CGI::unescape_html(movie_data['display_title']),
			description: self::description_to_html(movie_data['plain_short_description']),
			runtime: movie_data['runtime'],
			production_year: movie_data['production_year'],
			image_url: self::poster_url(movie_data['poster']))
		return movie
	end

	private
	def self.description_to_html(desc)
		CGI::unescape_html(desc)
		.gsub(/\r\n|\r|\n/, '<br/>')
		.gsub(/\*(.{,80})\*/, '<strong>\1</strong>')
		.gsub(/(\()?"(.+?) \(\2\)":/) { if $1 then "(#{$2})" else $2 end }
	end

	def self.poster_url(pd)
		"#{pd['base_url']+pd['photo_id']}/#{pd['file_name_base']}.#{pd['extension']}" if pd.is_a? Hash
	end
end
