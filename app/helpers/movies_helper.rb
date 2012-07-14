module MoviesHelper
	def image_to_format(image_url, format)
		if image_url
			image_url.gsub(/\.(jpg|jpeg|png|gif)$/i, "_#{format}.\\1")
		else
			'placeholder.png'
		end
	end
end