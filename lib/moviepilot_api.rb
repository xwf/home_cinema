class MoviepilotApi
	include HTTParty
	base_uri 'www.moviepilot.de'

  def initialize(api_key)
    @api_key = api_key
  end

	def movie_search(q, query_params={}, params={})
		options = {query: {q: q, api_key: @api_key}.merge(query_params)}.merge(params)
		self.class.get('/searches/movies.json', options)
	end

	def get_movie(movie_id, query_params={}, params={})
		path = URI::parse(movie_id).path rescue "/movies/#{movie_id}"
		options = {query: {api_key: @api_key}.merge(query_params)}.merge(params)
		self.class.get("#{path}.json", options)
	end
end
