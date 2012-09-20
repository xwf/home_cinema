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

	def format_description(description, shorten=true)
		simple_format(first_words(html_escape(description), shorten ? 130 : -1), {}, sanitize: false)
		.gsub(/\*([^*]+)\*/, '<strong>\1</strong>')
		.html_safe
	end
end