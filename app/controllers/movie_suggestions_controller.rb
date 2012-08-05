
class MovieSuggestionsController < ApplicationController

	before_filter :init_fields

	# GET /movie_suggestions
  # GET /movie_suggestions.json
  def index		
    @movie_suggestions = @show.movie_suggestions

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @movie_suggestions }
    end
  end

  # GET /movie_suggestions/1
  # GET /movie_suggestions/1.json
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @movie_suggestion }
    end
  end

  # GET /movie_suggestions/new
  # GET /movie_suggestions/new.json
  def new
		@movie_suggestion = @show.movie_suggestions.build(
			registration_id: params[:registration_id],
			movie_id: params[:movie_id]
		)
		@movie = @movie_suggestion.movie || Movie.new

    respond_to do |format|
			format.js
      format.html # new.html.erb
    end
  end

  # GET /movie_suggestions/1/edit
  def edit
    @movie = @movie_suggestion.movie
  end

  # POST /movie_suggestions
  # POST /movie_suggestions.json
  def create
    @movie_suggestion = @show.movie_suggestions.build(params[:movie_suggestion])

    respond_to do |format|
      if @movie_suggestion.save
        format.html { redirect_to @movie_suggestion, notice: 'Movie suggestion was successfully created.' }
        format.json { render json: @movie_suggestion, status: :created, location: @movie_suggestion }
      else
        format.html { render action: "new" }
        format.json { render json: @movie_suggestion.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /movie_suggestions/1
  # PUT /movie_suggestions/1.json
  def update
    respond_to do |format|
      if @movie_suggestion.update_attributes(params[:movie_suggestion])
        format.html { redirect_to @movie_suggestion, notice: 'Movie suggestion was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @movie_suggestion.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /movie_suggestions/1
  # DELETE /movie_suggestions/1.json
  def destroy
    @movie_suggestion.destroy

    respond_to do |format|
      format.html { redirect_to movie_suggestions_url }
      format.json { head :no_content }
    end
  end

	protected
	def init_fields
		if params[:id]
			@movie_suggestion = MovieSuggestion.find(params[:id])
			@show = @movie_suggestion.show
			@path = movie_suggestion_path(params[:id])
		elsif params[:show_id]
			@show = Show.find(params[:show_id])
			@path = show_movie_suggestions_path(params[:show_id])
		elsif params[:registration_id]
			# Could be optimized to a single SQL query
			@show = Registration.find(params[:registration_id]).show
			@path = registration_suggestion_path(params[:registration_id])
		end
	end
end
