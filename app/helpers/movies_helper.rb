module MoviesHelper
	def poster_url(poster, format)
		if poster.is_a? Hash
			format = '_'+format unless format.nil? || format.empty?
			"#{poster['base_url']+poster['photo_id']}/#{poster['file_name_base']+format}.#{poster['extension']}"
		else
			'/assets/rails.png' #TODO
		end
	end

	def unescape(str)
		CGI::unescape_html(str)
	end
end