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
end
