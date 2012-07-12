module MoviesHelper
	def poster_to_format(poster_url, format)
		if poster_url
			poster_url.gsub(/\.(?:jpg|jpeg|png|gif)$/i, "_#{format}\0")
		else
			'placeholder.png'
		end
	end
end