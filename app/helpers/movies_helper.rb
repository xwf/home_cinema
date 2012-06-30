module MoviesHelper
	def poster_url(pd)
		unless pd.nil?
			"#{pd['base_url']}#{pd['photo_id']}/#{pd['file_name_base']}_poster.#{pd['extension']}"
		else
			'/assets/rails.png' #TODO
		end
	end
end
