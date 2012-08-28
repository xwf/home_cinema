module MoviesHelper
	def poster_url(movie, format)
		if movie.poster_file_size
			movie.poster.url(format.to_sym)
		elsif movie.moviepilot_image_url
			movie.moviepilot_image_url.gsub(/\.(jpg|jpeg|png|gif)$/i, "_#{format}.\\1")
		else
			'placeholder.png'
		end
	end

	def format_description(description)
		simple_format(html_escape(description), {}, sanitize: false)
		.gsub(/\*(.{,80})\*/, '<strong>\1</strong>')
		.html_safe
	end
end