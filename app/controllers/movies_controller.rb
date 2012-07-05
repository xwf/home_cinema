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
		api = MoviepilotApi.new(Settings.moviepilot.api.key)
		search_query = params[:query] || params[:term]

		until search_query.nil? or search_query.empty?
			@response_data = api.movie_search(search_query, {per_page: 5}, {timeout: 2}) rescue nil
			break unless @response_data.is_a? Hash
			if @response_data.has_key? 'total_entries' and @response_data['total_entries'] > 0
				respond_to do |format|
					format.js
					format.json { render_preview_data }
				end
				return
			elsif @response_data.has_key? 'suggestions'
				search_query = @response_data['suggestions'].first
			else break
			end
		end
		
		head :no_content
	end

	private
	def render_preview_data
		result = @response_data['movies'].map do |search_result|
			title = CGI::unescape_html(search_result['display_title'])
			{label: render_to_string(partial: 'movies/search_result', formats: :html, locals: {search_result: search_result}),	value: title}
		end
		if @response_data['total_entries'] > 5
			result << {label: "<em>Alle #{@response_data['total_entries']} Treffer anzeigen</em>"}
		end
		render json: result
	end
end
