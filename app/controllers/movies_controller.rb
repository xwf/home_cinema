require 'moviepilot_api'
class MoviesController < ApplicationController
  # GET /movies
  # GET /movies.json
  def index
    @movies = Movie.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @movies }
    end
  end

  # GET /movies/1
  # GET /movies/1.json
  def show
    @movie = Movie.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @movie }
    end
  end

  # GET /movies/new
  # GET /movies/new.json
  def new
    @movie = Movie.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @movie }
    end
  end

  # GET /movies/1/edit
  def edit
    @movie = Movie.find(params[:id])
  end

  # POST /movies
  # POST /movies.json
  def create
		if moviepilot_url = params[:movie][:moviepilot_url]
			api = MoviepilotApi.new(Settings.moviepilot.api.key)
			movie_data = api.get_movie(moviepilot_url)
			@movie = Movie.build_from_api_result(movie_data)
		else
			@movie = Movie.new(params[:movie])
		end

    respond_to do |format|
      if @movie.save
        format.html { redirect_to @movie, notice: 'Movie was successfully created.' }
        format.json { render json: @movie, status: :created, location: @movie }
      else
        format.html { render action: "new" }
        format.json { render json: @movie.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /movies/1
  # PUT /movies/1.json
  def update
    @movie = Movie.find(params[:id])

    respond_to do |format|
      if @movie.update_attributes(params[:movie])
        format.html { redirect_to @movie, notice: 'Movie was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @movie.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /movies/1
  # DELETE /movies/1.json
  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy

    respond_to do |format|
      format.html { redirect_to movies_url }
      format.json { head :no_content }
    end
  end

	def search
		search_query = params[:query] || params[:term]

		if search_query.strip.length > 1
			@page = params[:page] || 1
			@movie_search = MovieSearch.find_or_initialize_by_query(search_query.downcase)
			@movies = get_from_cache || get_from_api

			@movie_search.save

			respond_to do |format|
				if @movies
					format.js
					format.json { render_preview_data }
				else
					format.js { render 'movies/search_failed' }
					format.json { head :no_content }
				end
			end
		else
			head :no_content
		end
	end

	private
	def get_from_cache
		MovieSearchResult.where(
			movie_search_id: @movie_search.id,
			result_number: [(@page-1)*5...@page*5]
		).map { |result| result.movie } unless @movie_search.new_record?
	end

	def get_from_api
		# initialize API
		api = MoviepilotApi.new(Settings.moviepilot.api.key)

		while
			response_data = api.movie_search(@movie_search.query, {per_page: 5, page: @page}, {timeout: 5}) rescue nil
			return nil unless response_data.is_a? Hash
			if response_data.has_key? 'total_entries' and response_data['total_entries'] > 0
				@movie_search.total_results = response_data['total_entries']
				return response_data['movies'].each_with_index.map do |movie_data, i|
					@movie_search.results.build(
						movie: Movie.build_from_api_result(movie_data),
						result_number: i
					).movie
				end				
			elsif response_data.has_key? 'suggestions'
				@movie_search.query = response_data['suggestions'].first
			else
				return nil
			end
		end
	end

	def render_preview_data
		result = @movies.map do |movie|
			{label: render_to_string(partial: 'movies/search_result', formats: :html, object: movie)}
		end
		if @movie_search.total_results > 5
			result << {label: "<em>Alle #{@movie_search.total_results} Treffer anzeigen</em>"}
		end
		render json: result
	end
end
