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
		@movie = Movie.new(params[:movie])
		
    respond_to do |format|
      if @movie.save
				format.json { render json: { movie: render_to_string(@movie, formats: :html), movie_id: @movie.id } }
				format.html do
					render json: { movie: CGI::escape_html(render_to_string(@movie, formats: :html).gsub('"', "'")), movie_id: @movie.id }
				end
      else
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
		search_query = (params[:query] || params[:term] || '').strip.downcase

		if search_query.length > 1
			@page = (params[:page] || 1).to_i
			@movie_search = MovieSearch.find_or_initialize_by_query(search_query)

			MovieSearch.transaction do
				@movies, @suggestions = get_from_cache || get_from_api
			end

			respond_to do |format|
				if @movies
					format.js
					format.json { render_preview_data }
				elsif @suggestions
					format.js { render 'movies/search/no_results' }
					format.json { head :no_content } #TODO: Show suggestions in popup box
				else
					format.js { render 'movies/search/error' }
					format.json { head :no_content }
				end
			end
		else
			head :no_content
		end
	end

	private
	def get_from_cache
		# return imidiately if this is a new search
		unless @movie_search.new_record?
			# init variables
			from = (@page - 1) * 5;	to = @page * 5
			# do DB query
			movies = MovieSearchResult.where(
				movie_search_id: @movie_search.id,
				result_number: [from...to]
			).map { |result| result.movie }
			# calculate expected return count
			expected_return_count = [5, @movie_search.total_results - from].min
			# only return DB result if count matches
			if expected_return_count == movies.size
				logger.info "Returning results #{from+1}-#{to} for query '#{@movie_search.query}' from cache"
				return movies, nil
			else
				unless movies.empty?
					# delete all cached results unless no results at all were returned
					logger.warn "Inconsistent cache lookup! Destroying cached results for query '#{@movie_search.query}'"
					@movie_search.results.clear
				end
				return nil
			end
		end
	end

	def get_from_api
		# initialize API
		api = MoviepilotApi.new(Settings.moviepilot.api.key)

		# send search request to API
		response_data = api.movie_search(@movie_search.query, {per_page: 5, page: @page}, {timeout: 5}) rescue nil
		# return nil if the API didn't return a result in time
		return nil unless response_data.is_a? Hash
		if response_data.has_key? 'total_entries' and response_data['total_entries'] > 0
			# set total results
			@movie_search.total_results = response_data['total_entries']
			# save the MovieSearch object
			@movie_search.save
			# calculate result offset
			offset = (@page - 1) * 5
			# iterate over the returned movie results
			movies = response_data['movies'].each_with_index.map do |movie_data, i|
				# build a Movie object from the returned data...
				movie = Movie.build_from_api_result(movie_data)
				# ...and try to save it
				if movie.save
					# if successful, build an MovieSearchResult from it
					# and add the movie object to the return array
					@movie_search.results.build(
						movie: movie,
						result_number: i + offset
					).movie
				else
					# if the save operation failed, log an error...
					logger.error "Movie could not be saved! Object: #{movie.attributes}; Errors: #{movie.errors.to_a}"
					# and add nil to the return array
					nil
				end
			end

			# try to save the MovieSearch object again; destroy it on fail
			@movie_search.save || @movie_search.destroy && logger.warn(
				'MovieSearch could not be saved and was therefore destroyed! ' +
				"Errors: #{@movie_search.errors.to_a}")

			# remove all nil entries from the return array and return it
			logger.info "Returning results #{offset+1}-#{offset+5} for query '#{@movie_search.query}' from API"
			return movies.compact, nil

		elsif response_data.has_key? 'suggestions'
			# return the array of search suggestions if present
			return nil, response_data['suggestions']
		else
			# return nil if neither movie results nor suggestions were returned
			return nil
		end
	end

	def render_preview_data
		result = @movies.map do |movie|
			{label: render_to_string(partial: 'movies/search/result', formats: :html, object: movie), value: '', id: movie.id}
		end
		if @movie_search.total_results > 5
			result << {label: "<em>Alle #{@movie_search.total_results} Treffer anzeigen</em>", value: params[:term], show_all: true}
		end
		render json: result
	end
end
